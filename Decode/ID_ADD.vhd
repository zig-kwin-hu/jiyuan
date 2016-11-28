----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:33:14 11/27/2016 
-- Design Name: 
-- Module Name:    ID_ADD - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ID_ADD is
    Port ( PCRegister : in  STD_LOGIC_VECTOR (15 downto 0);
           immediate : in  STD_LOGIC_VECTOR (15 downto 0);
           PC_calc : out  STD_LOGIC_VECTOR (15 downto 0));
end ID_ADD;

architecture Behavioral of ID_ADD is

begin
	process(PCRegister, immediate) is
	begin
		PC_calc <= PCRegister + immediate;
	end process;

end Behavioral;

