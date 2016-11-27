----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:53:36 11/24/2016 
-- Design Name: 
-- Module Name:    Register - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg is
    Port ( reg_in1 : in  STD_LOGIC_VECTOR (3 downto 0);
           reg_in2 : in  STD_LOGIC_VECTOR (3 downto 0);
           reg_write_loc : in  STD_LOGIC_VECTOR (3 downto 0);
           reg_write_data : in  STD_LOGIC_VECTOR (15 downto 0);
           reg_write_signal : in  STD_LOGIC;
           reg_out1 : out  STD_LOGIC_VECTOR (15 downto 0);
           reg_out2 : out  STD_LOGIC_VECTOR (15 downto 0);
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC);
end reg;

architecture Behavioral of Reg is
	Type state is (s0, s1);
	signal current_state : state := s0;
	Type ar is array(12 downto 0) of STD_LOGIC_VECTOR (15 downto 0);
	signal reg_mem : ar;
begin
	process(clk,rst) is
	begin
		if (rst = '0') then
			for i in 12 downto 0 loop
				reg_mem(i) <= "0000000000000000";
			end loop;
		elsif rising_edge (clk) then
			case current_state is
				when s0 =>
					if (reg_write_signal = '1') then
						reg_mem(conv_integer(reg_write_loc)) <= reg_write_data;
					end if;
					current_state <= s1;
				when s1 =>
					reg_out1 <= reg_mem(conv_integer(reg_in1));
					reg_out2 <= reg_mem(conv_integer(reg_in2));
					current_state <= s0;
			end case;
		end if;
	end process;
				


end Behavioral;

