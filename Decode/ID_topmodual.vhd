----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:10:27 11/27/2016 
-- Design Name: 
-- Module Name:    ID_topmodual - Behavioral 
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

entity ID_topmodual is
	Port( 
    IFIDWrite 		: in STD_LOGIC;
    clk 				: in STD_LOGIC;
    rst 				: in STD_LOGIC;
    PCin 			: in STD_LOGIC_VECTOR(15 downto 0);
	 
	 Reg1_out 		: out STD_LOGIC_VECTOR(15 downto 0);
	 Reg2_out 		: out STD_LOGIC_VECTOR(15 downto 0);
	 ALUOP 			: out STD_LOGIC_VECTOR(3 downto 0);
	 ALUSRC 			: out STD_LOGIC;
	 RegDst 			: out STD_LOGIC_VECTOR(3 downto 0);
	 immediate_out	: out STD_LOGIC_VECTOR(15 downto 0);
	 immediate_in2	: out STD_LOGIC_VECTOR(7 downto 0);
	 MemRead			: out STD_LOGIC;
	 MemWrite		: out STD_LOGIC;
	 MemToReg		: out STD_LOGIC_VECTOR(1 downto 0);
	 RegWrite		: out STD_LOGIC;
	 
    reg_write_loc 	: in  STD_LOGIC_VECTOR (3 downto 0);
    reg_write_data 	: in  STD_LOGIC_VECTOR (15 downto 0);
    reg_write_signal : in  STD_LOGIC
	 
	 );
end ID_topmodual;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

architecture Behavioral of ID_topmodual is

component IFIDRegister is
	Port( 
    IFIDWrite 		: in STD_LOGIC;
    clk 				: in STD_LOGIC;
    rst 				: in STD_LOGIC;
    PCin 			: in STD_LOGIC_VECTOR(15 downto 0);
	 
	 Reg1 			: out STD_LOGIC_VECTOR(3 downto 0);
	 Reg2 			: out STD_LOGIC_VECTOR(3 downto 0);
	 ALUOP 			: out STD_LOGIC_VECTOR(3 downto 0);
	 ALUSRC 			: out STD_LOGIC;
	 RegDst 			: out STD_LOGIC_VECTOR(3 downto 0);
	 immediate 		: out STD_LOGIC_VECTOR(7 downto 0);
	 immediate_n 	: out STD_LOGIC_VECTOR(1 downto 0);-- "00":3 "01":4 "10":5 "11":8
	 immediate_arith:out STD_LOGIC; -- 1 Arith; 0 Logic
	 MemRead			: out STD_LOGIC;
	 MemWrite		: out STD_LOGIC;
	 MemToReg		: out STD_LOGIC_VECTOR(1 downto 0);
	 RegWrite		: out STD_LOGIC
	 
	 --err				: out STD_LOGIC
	 
	 );
end component IFIDRegister;

--IFIDRegister - reg
signal Reg1 : STD_LOGIC_VECTOR(3 downto 0);
signal Reg2 : STD_LOGIC_VECTOR(3 downto 0);

--IFIDRegister - immediate_expand
signal immediate_in		: STD_LOGIC_VECTOR(7 downto 0);
signal immediate_n 		: STD_LOGIC_VECTOR(1 downto 0);
signal immediate_arith	: STD_LOGIC;

component immediate_expand is
    Port ( immediate_in : in  STD_LOGIC_VECTOR (7 downto 0);
           immediate_out : out  STD_LOGIC_VECTOR (15 downto 0);
           immediate_n : in  STD_LOGIC_VECTOR (1 downto 0);
           immediate_arith : in  STD_LOGIC;
			  
			  clk :in STD_LOGIC;
			  rst :in STD_LOGIC);
end component immediate_expand;

component reg is
    Port ( reg_in1 : in  STD_LOGIC_VECTOR (3 downto 0);
           reg_in2 : in  STD_LOGIC_VECTOR (3 downto 0);
           reg_write_loc : in  STD_LOGIC_VECTOR (3 downto 0);
           reg_write_data : in  STD_LOGIC_VECTOR (15 downto 0);
           reg_write_signal : in  STD_LOGIC;
           reg_out1 : out  STD_LOGIC_VECTOR (15 downto 0);
           reg_out2 : out  STD_LOGIC_VECTOR (15 downto 0);
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC);
end component reg;

begin
	immediate_in2 <= immediate_in;

	IFIDRegister_comp: IFIDRegister port map(
		IFIDWrite => IFIDWrite,
		clk => clk,
		rst => rst,
		PCin => PCin,
		Reg1 => Reg1,
		Reg2 => Reg2,
		ALUOP => ALUOP,
		ALUSRC => ALUSRC,
		RegDst => RegDst,
		immediate => immediate_in,
		immediate_n => immediate_n,
		immediate_arith => immediate_arith,
		MemRead => MemRead,
		MemWrite => MemWrite,
		MemToReg => MemToReg,
		RegWrite => RegWrite
	);
	
	immediate_expand_comp : immediate_expand port map(
		immediate_in => immediate_in,
		immediate_out => immediate_out,
		immediate_n => immediate_n,
		immediate_arith => immediate_arith,
		
		clk => clk,
		rst => rst
	);
	
	reg_comp : reg port map(
		reg_in1 => Reg1,
		reg_in2 => Reg2,
		reg_write_loc => reg_write_loc,
		reg_write_data => reg_write_data,
		reg_write_signal => reg_write_signal,
		reg_out1 => Reg1_out,
		reg_out2 => Reg2_out,
		
		clk => clk,
		rst => rst
	);


end Behavioral;

