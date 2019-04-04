Ilibrary IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Multiplier is
port(
A : in std_logic_vector(7 downto 0);
B : in std_logic_vector(7 downto 0);
C : out std_logic_vector(10 downto 0)
);
end Multiplier;

-------------------------------------------------------------------------------------------------------------------------------
architecture Behavioral of Multiplier is


begin

process(A,B)

variable ADD,SUB,PRO,AUX : std_logic_vector(16 downto 0);

	begin
		
		
		ADD := (others => '0'); 
		SUB := (others => '0');
		PRO := (others => '0');
		
		ADD(16 downto 9) := A;
		
		--if A(7) = '0' then
		SUB(16 downto 9) := not(A)+1;
		--else
		--	SUB(16 downto 9) := not(A)-1;
		--end if;
		
		PRO(8 downto  1) := B;
		
		for i in 0 to 7 loop
			case PRO(1 downto 0) is
				when "00" => AUX := PRO;
				when "01" => AUX := PRO + ADD;
				when "10" => AUX := PRO + SUB;
				when "11" => AUX := PRO;
				when others => null;
			end case;	 
			PRO := AUX (16) & AUX(16 downto 1);
		end loop;
											 							
		C <= PRO(11 downto 1);   
	end
process;


end Behavioral;

