library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.numeric_std.all;


-------------------------------------------------------------------------------------------------------------------------------
entity bin2bcd_9bit is
Port ( binIN : in  STD_LOGIC_VECTOR (10 downto 0); -- NumbeR that has to be converted		
sign : out STD_LOGIC; -- The sign of the number
ones : out  STD_LOGIC_VECTOR (3 downto 0); -- The digits for ones
tens : out  STD_LOGIC_VECTOR (3 downto 0); -- The digits for tens
hundreds : out  STD_LOGIC_VECTOR (3 downto 0) -- The digits for hundreds
);
end bin2bcd_9bit;

-------------------------------------------------------------------------------------------------------------------------------
architecture Behavioral of bin2bcd_9bit is

begin

	process(binIN)

  variable temp : STD_LOGIC_VECTOR (9 downto 0); -- Will keep the number during the algorithm
  
  variable bcd : UNSIGNED (11 downto 0) := (others => '0'); -- Will contain the partial result during the algorithm
  
  begin
    bcd := (others => '0');
    
	 if binIN(10) = '0' then -- If the value is positive, load it directly , otherwise change it to it's negative counterpart
		temp(9 downto 0) := binIN(9 downto 0);
	 else
		temp(9 downto 0) := (not binIN(9 downto 0)) + "0000000001"; -- Normal 2C conversion
    end if;
	 
    for i in 0 to 8 loop
    
      if bcd(3 downto 0) > 4 then  -- the check for ones
        bcd(3 downto 0) := bcd(3 downto 0) + 3;
      end if;
      
      if bcd(7 downto 4) > 4 then  -- the check for tens
        bcd(7 downto 4) := bcd(7 downto 4) + 3;
      end if;
    
      if bcd(11 downto 8) > 4 then  -- the check for hundreds
        bcd(11 downto 8) := bcd(11 downto 8) + 3;
      end if;
    
      bcd := bcd(10 downto 0) & temp(8); -- Shift BCD to the left and fill with the 9th bit of temp
    
      temp := temp(8 downto 0) & '0'; -- Shift temp to the left 
    
    end loop;
 
    -- set outputs
    ones <= STD_LOGIC_VECTOR(bcd(3 downto 0));
    tens <= STD_LOGIC_VECTOR(bcd(7 downto 4));
    hundreds <= STD_LOGIC_VECTOR(bcd(11 downto 8));
    sign <= binIN(10); -- Sign will always be on the 10th bit
  
  end process bcd1;            
  
end Behavioral;