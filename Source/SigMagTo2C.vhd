

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity SigMagTo2C is
port(
A : in std_logic_vector(7 downto 0);
B : out std_logic_vector(7 downto 0)
);
end SigMagTo2C;

-------------------------------------------------------------------------------------------------------------------------------
architecture Behavioral of SigMagTo2C is

begin

process
begin
	if A(7) = '0' then
		B <= A;
	else
		B(6 downto 0) <= ((not A(6 downto 0)) + "0000001");--Normal conversion algorithm
		
		B(7) <= '1';
	end if;
end process;


end Behavioral;

