----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:43:32 11/27/2016 
-- Design Name: 
-- Module Name:    ID_PCselector - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ID_PCselector is
    Port ( PC_calc_res : in  STD_LOGIC_VECTOR (15 downto 0);
           Register_in : in  STD_LOGIC_VECTOR (15 downto 0);
           PCout : out  STD_LOGIC_VECTOR (15 downto 0);
			  isJRorder : in STD_LOGIC;
			  
			  RegIn_sidepath: in STD_LOGIC_VECTOR(15 downto 0);
			  signal_sidepath : in STD_LOGIC_VECTOR(1 downto 0)
			  );
end ID_PCselector;

architecture Behavioral of ID_PCselector is

begin
	PCselector : process(isJRorder, Register_in, PC_calc_res, signal_sidepath, RegIn_sidepath)
	begin
		if (signal_sidepath = "01") then
			if (isJRorder = '1') then
				PCout <= RegIn_sidepath;
			else
				PCout <= PC_calc_res;
			end if;
		else
			if (isJRorder = '1') then
				PCout <= Register_in;
			else
				PCout <= PC_calc_res;
			end if;
		end if;
	end process PCselector;

end Behavioral;

