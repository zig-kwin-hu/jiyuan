----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:38:19 11/27/2016 
-- Design Name: 
-- Module Name:    ID_JMPControl - Behavioral 
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

entity ID_JMPControl is
    Port ( isJmporder 		: in  STD_LOGIC_VECTOR (1 downto 0);
           regEqualToZero 	: in  STD_LOGIC_VECTOR (1 downto 0);
           jmp 				: out  STD_LOGIC);
end ID_JMPControl;

architecture Behavioral of ID_JMPControl is
signal result : STD_LOGIC_VECTOR(1 downto 0);
begin
	result <= isJmporder or regEqualToZero;
	jmpprocess : process(result)
	begin
		if (result = "11") then
			jmp <= '1';
		else
			jmp <= '0';
		end if;
	end process;

end Behavioral;

