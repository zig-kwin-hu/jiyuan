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
    IFIDWrite 		: in STD_LOGIC; -- unused now
    clk 				: in STD_LOGIC;
    rst 				: in STD_LOGIC;
    PCin 			: in STD_LOGIC_VECTOR(15 downto 0);
	 PCRegister		: in STD_LOGIC_VECTOR(15 downto 0);
	 
	 Reg1_out 		: out STD_LOGIC_VECTOR(15 downto 0);
	 Reg2_out 		: out STD_LOGIC_VECTOR(15 downto 0);
	 ALUOP 			: out STD_LOGIC_VECTOR(3 downto 0);
	 ALUSRC 			: out STD_LOGIC;
	 RegDst 			: out STD_LOGIC_VECTOR(3 downto 0);
	 immediate_out	: out STD_LOGIC_VECTOR(15 downto 0);
	 immediate_in2	: out STD_LOGIC_VECTOR(10 downto 0); -- signal for debug
	 MemRead			: out STD_LOGIC;
	 MemWrite		: out STD_LOGIC;
	 MemToReg		: out STD_LOGIC_VECTOR(1 downto 0);
	 RegWrite		: out STD_LOGIC;
	 PCout			: out STD_LOGIC_VECTOR(15 downto 0);
	 
    reg_write_loc 	: in  STD_LOGIC_VECTOR (3 downto 0);
    reg_write_data 	: in  STD_LOGIC_VECTOR (15 downto 0);
    reg_write_signal : in  STD_LOGIC;
	 
	 isBubble : in STD_LOGIC;
	 
	 jmp	: out STD_LOGIC
	 
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
	 immediate 		: out STD_LOGIC_VECTOR(10 downto 0);
	 immediate_n 	: out STD_LOGIC_VECTOR(2 downto 0);-- "00":3 "01":4 "10":5 "11":8
	 immediate_arith:out STD_LOGIC; -- 1 Arith; 0 Logic
	 MemRead			: out STD_LOGIC;
	 MemWrite		: out STD_LOGIC;
	 MemToReg		: out STD_LOGIC_VECTOR(1 downto 0);
	 RegWrite		: out STD_LOGIC;
	 
	 isBubble		: in STD_LOGIC;
	 
	 isJRorder		: out STD_LOGIC;
	 isJmporder		: out STD_LOGIC_VECTOR(1 downto 0)
	 
	 --err				: out STD_LOGIC
	 
	 );
end component IFIDRegister;

--IFIDRegister - reg
signal Reg1 : STD_LOGIC_VECTOR(3 downto 0);
signal Reg2 : STD_LOGIC_VECTOR(3 downto 0);

signal Reg1out_temp : STD_LOGIC_VECTOR(15 downto 0);

--IFIDRegister - immediate_expand
signal immediate_in		: STD_LOGIC_VECTOR(10 downto 0);
signal immediate_n 		: STD_LOGIC_VECTOR(2 downto 0);
signal immediate_arith	: STD_LOGIC;
signal immediate_res		: STD_LOGIC_VECTOR(15 downto 0);

--IFIDRegister - ID_PCselector
signal isJRorder_temp : STD_LOGIC;
signal isJmporder_temp : STD_LOGIC_VECTOR(1 downto 0);

component immediate_expand is
    Port ( immediate_in : in  STD_LOGIC_VECTOR (10 downto 0);
           immediate_out : out  STD_LOGIC_VECTOR (15 downto 0);
           immediate_n : in  STD_LOGIC_VECTOR (2 downto 0);
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
			  PCRegister		: in STD_LOGIC_VECTOR(15 downto 0);
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  
			  reg1zero : out STD_LOGIC_VECTOR(1 downto 0)
			 );
end component reg;
--...
signal reg1zero_temp : STD_LOGIC_VECTOR(1 downto 0);

component ID_ADD is
    Port ( PCRegister : in  STD_LOGIC_VECTOR (15 downto 0);
           immediate : in  STD_LOGIC_VECTOR (15 downto 0);
           PC_calc : out  STD_LOGIC_VECTOR (15 downto 0));
end component ID_ADD;
--...
signal PC_calc_res : STD_LOGIC_VECTOR(15 downto 0);

component ID_PCselector is
    Port ( PC_calc_res : in  STD_LOGIC_VECTOR (15 downto 0);
           Register_in : in  STD_LOGIC_VECTOR (15 downto 0);
           PCout : out  STD_LOGIC_VECTOR (15 downto 0);
			  isJRorder : in STD_LOGIC
			  );
end component ID_PCselector;

component ID_JMPControl is
    Port ( isJmporder 		: in  STD_LOGIC_VECTOR (1 downto 0);
           regEqualToZero 	: in  STD_LOGIC_VECTOR (1 downto 0);
           jmp 				: out  STD_LOGIC);
end component ID_JMPControl;

begin
	immediate_in2 <= immediate_in;
	Reg1_out <= Reg1out_temp;

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
		RegWrite => RegWrite,
		
		isBubble => isBubble,
		
		isJRorder => isJRorder_temp,
		isJmporder => isJmporder_temp
	);
	
	immediate_out <= immediate_res; -- for ID_ADD
	immediate_expand_comp : immediate_expand port map(
		immediate_in => immediate_in,
		immediate_out => immediate_res,
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
		reg_out1 => Reg1out_temp, --Caution!
		reg_out2 => Reg2_out,
		PCRegister => PCRegister,
		
		clk => clk,
		rst => rst,
		reg1zero => reg1zero_temp
	);
	
	ID_ADD_comp : ID_ADD port map(
		PCRegister => PCRegister,
	   immediate => immediate_res,
	   PC_calc => PC_calc_res
	);
	
	ID_PCselector_comp : ID_PCselector port map(
		PC_calc_res => PC_calc_res,
      Register_in => Reg1out_temp,
      PCout => PCout,
		isJRorder => isJRorder_temp
	);
	
	ID_JMPControl_comp : ID_JMPControl port map( 
		isJmporder 		=> isJmporder_temp,
		regEqualToZero => reg1zero_temp,		--from reg
		jmp 				=> jmp
	);
	
end Behavioral;

