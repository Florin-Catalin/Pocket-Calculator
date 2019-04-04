
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

use IEEE.NUMERIC_STD.ALL;


entity Divider is
port(
A : in std_logic_vector(7 downto 0);--Numerator
B : in std_logic_vector(7 downto 0);--Denominator
C : out std_logic_vector(10 downto 0));--Easier to use in main by using 11 bits, even if the integer division can not use more than the numerator
end Divider;

architecture Behavioral of Divider is

begin

process(A,B)
Variable Numerator,Denominator,Quotient : std_logic_vector(7 downto 0);
begin
	Quotient := "00000000";
	Numerator := A;
	Denominator := B;
	for i in 127 downto 0 loop
		if Numerator(6 downto 0) >= Denominator(6 downto 0) then -- If the subtraction makes sense then the qutioent should be incremented
			Numerator(6  downto 0) := Numerator(6 downto 0) - Denominator(6 downto 0);
			Quotient := Quotient + '1';
		end if;
	end loop;
	
	
	if ((A(7) xor B(7)) = '0')  then -- Again, normalizing the result depending on sign
		C(9 downto 7) <= "000";
		C(6 downto 0) <= Quotient(6 downto 0);	 
	else
		C(9 downto 7) <= "111";
		C(6 downto 0) <= Quotient(6 downto 0);	 
	end if;
	
	C(10) <= A(7) xor B(7); -- The sign of the division
end
process;

end Behavioral;

