
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Seg7 is
port(
digit0: in std_logic_vector(3 downto 0);
digit1: in std_logic_vector(3 downto 0);
digit2: in std_logic_vector(3 downto 0);
digit3: in std_logic_vector(3 downto 0);
CLK : in std_logic;
seg: out std_logic_vector(6 downto 0);
ano : out std_logic_vector(3 downto 0)
);
end Seg7;

-------------------------------------------------------------------------------------------------------------------------------

architecture Behavioral of Seg7 is

signal cnt : std_logic_vector(15 downto 0);
signal aux : std_logic_vector(3 downto 0);
begin
		
	process(CLK)
		begin
			if rising_edge( CLK ) then
				cnt <= cnt + 1;
			end if;
		end 
	process;
	
	process(cnt( 15 ) , cnt( 14 ))
		begin
		
			case cnt( 15 downto 14 ) is
			
			when  "00"  => ano <= "1110";
			when  "01"  => ano <= "1101";
			when  "10"  => ano <= "1011";
			when  "11"  => ano <= "0111";
			
			when others => ano <= "0000";
			
			end case;
			
			case cnt( 15 downto 14 ) is
			
			when  "00"  => aux <= digit0;
			when  "01"  => aux <= digit1;
			when  "10"  => aux <= digit2;
			when  "11"  => aux <= digit3;
			
			when others => aux <= "1111";
			
			end case;
		end 
	process;
	
	process(aux)
		begin
			case  aux is
				when "0000" => seg <="1000000";   --0
				when "0001" => seg <="1111001";   --1
				when "0010" => seg <="0100100";   --2
				when "0011" => seg <="0110000";   --3
				when "0100" => seg <="0011001";   --4
				when "0101" => seg <="0010010";   --5
				when "0110" => seg <="0000010";   --6
				when "0111" => seg <="1111000";   --7
				when "1000" => seg <="0000000";   --8
				when "1001" => seg <="0010000";   --9
			
				when "1010" => seg <="0111111";   -- minus
				when others => seg <="1111111";   -- blank
			end case;
		end 
	process;
	
end Behavioral;
		
				