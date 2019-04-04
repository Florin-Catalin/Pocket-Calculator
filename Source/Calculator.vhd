library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity Calculator is
port(
Number: in std_logic_vector(7 downto 0);--Signed Mag
Buttons: in std_logic_vector(4 downto 0);
Clock: in std_logic;
Segments: out std_logic_vector(6 downto 0);
Anodes : out std_logic_vector(3 downto 0)
);
end Calculator;

architecture Behavioral of Calculator is

-------------------------------------------------------------------------------------------------------------------------------
component Multiplier is
port(
A : in std_logic_vector(7 downto 0);
B : in std_logic_vector(7 downto 0);
C : out std_logic_vector(10 downto 0)
);
end component;

-------------------------------------------------------------------------------------------------------------------------------
component Divider is
port(
A : in std_logic_vector(7 downto 0);--Deimpartit
B : in std_logic_vector(7 downto 0);--Impartitor
C : out std_logic_vector(10 downto 0));
end component;

-------------------------------------------------------------------------------------------------------------------------------
component SigMagTo2C is
port(
A : in std_logic_vector(7 downto 0);
B : out std_logic_vector(7 downto 0)
);
end component;


-------------------------------------------------------------------------------------------------------------------------------
component bin2bcd_9bit is
port ( binIN : in  STD_LOGIC_VECTOR (10 downto 0);
sign : out STD_LOGIC;
ones : out  STD_LOGIC_VECTOR (3 downto 0);
tens : out  STD_LOGIC_VECTOR (3 downto 0);
hundreds : out  STD_LOGIC_VECTOR (3 downto 0)
);
end component;


-------------------------------------------------------------------------------------------------------------------------------
component Seg7 is
port(
digit0: in std_logic_vector(3 downto 0);
digit1: in std_logic_vector(3 downto 0);
digit2: in std_logic_vector(3 downto 0);
digit3: in std_logic_vector(3 downto 0);
CLK : in std_logic;
seg: out std_logic_vector(6 downto 0);
ano : out std_logic_vector(3 downto 0)
);
end component;

-------------------------------------------------------------------------------------------------------------------------------
signal AdditionBufferSM,SubtractionBufferSM,DivisionBufferSM,MultiplicationBufferSM: std_logic_vector(10 downto 0);
signal Result,AdditionBuffer2C,SubtractionBuffer2C,DivisionBuffer2C,MultiplicationBuffer2C: std_logic_vector(10 downto 0);
signal FirstNumberSM,SecondNumberSM,FirstNumber2C,SecondNumber2C : std_logic_vector(7 downto 0);
signal Result100,Result10,Result1:std_logic_vector(3 downto 0);
signal ResSign :std_logic;
-------------------------------------------------------------------------------------------------------------------------------

-- Almost all the signals have both a Two's complement value and a Signed magnitude value
-- That is because I was unsure wether the algorithms I would use would require a 2C or SM form
-- The Addition/Subtraction/Multiplication/Division Buffers are used for containing the result and multiplexing it afterwards
-- Res sign is used to contain the sign of the result
-- Result100,Result10,Result1 each contain a digit of the result


begin

SMto2C1 : SigMagTo2C -- Change the first number from the SM input to the 2C processing
port map(FirstNumberSM,FirstNumber2C);

SMto2C2 : SigMagTo2C-- Change the second number from the SM input to the 2C processing
port map(SecondNumberSM,SecondNumber2C);

SMto2C3 : SigMagTo2C -- The division result requires changing from SM to 2C
port map(DivisionBufferSM(10) & DivisionBufferSM(6 downto 0),DivisionBuffer2C(7 downto 0));

BinToBcd : bin2bcd_9bit -- Convers the result from bin to bcd
port map(Result,ResSign,Result1,Result10,Result100);

Afi : Seg7 -- Sends each digit to the 7seg component,together with the sign and the required outputs
port map(Result1,Result10,Result100,"101"&(not ResSign),Clock,Segments,Anodes);
--"101"&(not ResSign) will be shown in the following way : if the sign is 1, then the number is negative and therefore a minus will be shown
-- otherwise it will show nothing


Div : Divider -- Division requires the operands to be in the SM form
port map(FirstNumberSM,SecondNumberSM,DivisionBufferSM);

Mul : Multiplier -- Multiplication requires the operands to be in the 2C form
port map(FirstNumber2C,SecondNumber2C,MultiplicationBuffer2C);

process(FirstNumberSM,SecondNumberSM) -- When the numbers change so do the addition/Subtraction buffers
begin
	AdditionBuffer2C(7 downto 0) <= FirstNumber2C + SecondNumber2C;--Low operator control due to size => Results are smaller than expected if an overflow occurs
	SubtractionBuffer2C(7 downto 0) <= FirstNumber2C + (not SecondNumber2C + "00000001"); -- Same as above - The sizes of the result and operands must be of the same size;

end 
process;

process(Number,Buttons) -- Changes when the numbers change or the buttons are pressed
begin

	-- Note that multiplication is the only operation which can create results bigger than 8 bits,
	-- therefore the other operations need to be normalised to the size of the multiplication result
	-- which in turn will sometimes require sign extensions for the bits 7,8,9 

	if Buttons(0) = '1' then --  The Addition operation
		Result(6 downto 0) <= AdditionBuffer2C(6 downto 0);
		if AdditionBuffer2C(7) = '0' then -- Value normalisation
			Result(9 downto 7) <= "000"; 
		else
			Result(9 downto 7) <= "111"; 
		end if;
			
		Result(10) <= AdditionBuffer2C(7);-- Adds the sign of the result to the 10th bit
	elsif Buttons(1) = '1' then --  The Subtraction operation
		Result(6 downto 0) <= SubtractionBuffer2C(6 downto 0);
		
		if SubtractionBuffer2C(7) = '0' then --- Value normalisation
			Result(9 downto 7) <= "000";
		else
			Result(9 downto 7) <= "111";
		end if;
		
		Result(10) <= SubtractionBuffer2C(7); -- Adds the sign of the result to the 10th bit
		
	 elsif Buttons(2) = '1' then --  The Multiplciation operation
		Result <= MultiplicationBuffer2C; -- Multiplication is the onyl operation which fills the whole 11 bits(11th is the sign bit), therefore
													 -- it requires no sign extension nor normalisation
		
	elsif Buttons(3) = '1' then --  The Division operation
	
		Result(10) <= DivisionBuffer2C(7);-- Adds the sign of the result to the 10th bit
		Result(6 downto 0) <= DivisionBuffer2C(6 downto 0);
		
	elsif rising_edge(Buttons(4)) then -- Adds buttons only on the rising edge to prevent double insertions
		FirstNumberSM <= SecondNumberSM; -- The numbers are shifted upon a new number insertion
		SecondNumberSM <= Number; -- The number is inserted
		
		if Number(7) = '0' then -- Depending on the sign, it is converted
			Result(6 downto 0) <= Number(6 downto 0);
			Result(9 downto 7) <= "000"; -- and the sign extension/normalsiation is done
		else
			Result(6 downto 0) <= (not Number(6 downto 0)) + "0000001";
			Result(9 downto 7) <= "111";
		end if;
		
		Result(10) <= Number(7); -- The 11th bit keeps the sign bit
	else
		Result <= "00000000000"; -- Othwerwise , if no button is pressed, four 0s should be shown on 7seg
	end if;
		
end
process;



end Behavioral;

