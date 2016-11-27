--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:33:15 11/27/2016
-- Design Name:   
-- Module Name:   H:/Decode/test_immediate.vhd
-- Project Name:  Decode
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: immediate_expand
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_immediate IS
END test_immediate;
 
ARCHITECTURE behavior OF test_immediate IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT immediate_expand
    PORT(
         immediate_in : IN  std_logic_vector(7 downto 0);
         immediate_out : OUT  std_logic_vector(15 downto 0);
         immediate_n : IN  std_logic_vector(1 downto 0);
         immediate_arith : IN  std_logic;
         clk : IN  std_logic;
         rst : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal immediate_in : std_logic_vector(7 downto 0) := (others => '0');
   signal immediate_n : std_logic_vector(1 downto 0) := (others => '0');
   signal immediate_arith : std_logic := '0';
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal immediate_out : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: immediate_expand PORT MAP (
          immediate_in => immediate_in,
          immediate_out => immediate_out,
          immediate_n => immediate_n,
          immediate_arith => immediate_arith,
          clk => clk,
          rst => rst
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
