----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    03:57:55 11/27/2016 
-- Design Name: 
-- Module Name:    immediate_expand - Behavioral 
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

entity immediate_expand is
    Port ( immediate_in : in  STD_LOGIC_VECTOR (10 downto 0);
           immediate_out : out  STD_LOGIC_VECTOR (15 downto 0);
           immediate_n : in  STD_LOGIC_VECTOR (2 downto 0);
           immediate_arith : in  STD_LOGIC;
			  
			  clk :in STD_LOGIC;
			  rst :in STD_LOGIC);
end immediate_expand;

architecture Behavioral of immediate_expand is
	Type state is (s0, s1);
	signal current_state : state := s0;
begin
	process(clk,rst) is
	begin
		if (rst = '0') then
			immediate_out <= "0000000000000000";
			current_state <= s0;
		elsif rising_edge (clk) then
			case current_state is
				when s0 =>
					current_state <= s1;
				when s1 =>
					case immediate_n is
						when "000" => --n = 3
							for i in 15 downto 3 loop
								immediate_out(i) <= immediate_arith and immediate_in(2);
							end loop;
							immediate_out(2 downto 0) <= immediate_in(2 downto 0);
							
						when "001" => --n = 4
							for i in 15 downto 4 loop
								immediate_out(i) <= immediate_arith and immediate_in(3);
							end loop;
							immediate_out(3 downto 0) <= immediate_in(3 downto 0);
							
						when "010" => --n = 5
							for i in 15 downto 5 loop
								immediate_out(i) <= immediate_arith and immediate_in(4);
							end loop;
							immediate_out(4 downto 0) <= immediate_in(4 downto 0);
							
						when "011" => --n = 8
							for i in 15 downto 8 loop
								immediate_out(i) <= immediate_arith and immediate_in(7);
							end loop;
							immediate_out(7 downto 0) <= immediate_in(7 downto 0);
							
						when "100" => --n = 11
							for i in 15 downto 11 loop
								immediate_out(i) <= immediate_arith and immediate_in(10);
							end loop;
							immediate_out(10 downto 0) <= immediate_in(10 downto 0);
							
						when others => --error
					end case;
					current_state <= s0;
			end case;
		end if;
	end process;


end Behavioral;

