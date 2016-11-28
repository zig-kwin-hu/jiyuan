----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:54:09 11/25/2016 
-- Design Name: 
-- Module Name:    IFIDRegister - Behavioral 
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

entity IFIDRegister is
	Port( 
    IFIDWrite : in STD_LOGIC;
    clk 				: in STD_LOGIC;
    rst 				: in STD_LOGIC;
    PCin 			: in STD_LOGIC_VECTOR(15 downto 0);
	 
	 Reg1 			: out STD_LOGIC_VECTOR(3 downto 0);
	 Reg2 			: out STD_LOGIC_VECTOR(3 downto 0);
	 ALUOP 			: out STD_LOGIC_VECTOR(3 downto 0);
	 ALUSRC 			: out STD_LOGIC;
	 RegDst 			: out STD_LOGIC_VECTOR(3 downto 0);
	 immediate 		: out STD_LOGIC_VECTOR(10 downto 0);
	 immediate_n 	: out STD_LOGIC_VECTOR(2 downto 0);-- "000":3 "001":4 "010":5 "011":8 ¡°100¡±:11
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
end IFIDRegister;

architecture Behavioral of IFIDRegister is
	Type state is (s0, s1, s2);
	signal current_state 	: state := s0;
	signal control_first5 	: STD_LOGIC_VECTOR(4 downto 0); --first 5 of PC
	signal control_first8 	: STD_LOGIC_VECTOR(7 downto 0); --first 8 of PC
	signal control_last2		: STD_LOGIC_VECTOR(1 downto 0); --last  2 of PC
	signal control_last5		: STD_LOGIC_VECTOR(4 downto 0); --last  5 of PC
	signal control_last8		: STD_LOGIC_VECTOR(7 downto 0); --last  8 of PC
	-- about immediate_n: 00 means
begin
	control_first5 <= PCin(15 downto 11);
	control_first8 <= PCin(15 downto 8);
	control_last2 <= PCin(1 downto 0);
	control_last5 <= PCin(4 downto 0);
	control_last8 <= PCin(7 downto 0);
	process(clk,rst) is
	begin
		if (rst = '0') then
			current_state <= s0;
		elsif rising_edge (clk) then
			if (isBubble = '1') then --NOP
				Reg1  (3 downto 0)<= "1111";
				Reg2  (3 downto 0)<= "1111";
				ALUOP (3 downto 0)<= "0000";
				ALUSRC				<= '1';
				RegDst(3 downto 0)<= "1111";
				
				immediate	(10 downto 0)<= "00000000000";
				immediate_n	(2 downto 0)<= "100";
				immediate_arith			<= '1';
				
				MemRead	<= '0';
				MemWrite	<= '0';
				MemToReg	<= "10";
				RegWrite <= '0';
			else
				--isJRorder
				if ((control_first5 = "11101") and (control_last8 = "00000000")) then -- JR order
					isJRorder 	<= '1';
					isJmporder 	<= "11";
				else
					isJRorder 	<= '0';
					if (control_first5 = "00010") then--B
						isJmporder 	<= "11";
					elsif((control_first5 = "00100") or 		--BEQZ
							(control_first8 = "01100000")) then	--BTEQZ 
						isJmporder 	<= "10";
					else
						isJmporder	<= "00";
					end if;
				end if;
				
				
					
				
				case current_state is
					when s0 =>
						--analyse the type of PCin
						case control_first5 is
							when "01001" => --ADDIU
								Reg1	(3)			<= '0';
								Reg1  (2 downto 0)<= PCin(10 downto 8);
								Reg2  (3 downto 0)<= "1111";
								ALUOP (3 downto 0)<= "0001";
								ALUSRC				<= '1';
								RegDst(3)			<= '0';
								RegDst(2 downto 0)<= PCin(10 downto 8);
								
								immediate	(7 downto 0)<= PCin(7 downto 0);
								immediate_n	(2 downto 0)<= "011";
								immediate_arith			<= '1';
								
								MemRead	<= '0';
								MemWrite	<= '0';
								MemToReg	<= "01";
								RegWrite <= '1';
								
							when "01000" => --ADDIU3
								Reg1	(3)			<= '0';
								Reg1  (2 downto 0)<= PCin(10 downto 8);
								Reg2  (3 downto 0)<= "1111";
								ALUOP (3 downto 0)<= "0001";
								ALUSRC				<= '1';
								RegDst(3)			<= '0';
								RegDst(2 downto 0)<= PCin(7 downto 5);
								
								immediate	(3 downto 0)<= PCin(3 downto 0);
								immediate_n	(2 downto 0)<= "001";
								immediate_arith			<= '1';
								
								MemRead	<= '0';
								MemWrite	<= '0';
								MemToReg	<= "01";
								RegWrite <= '1';
								
							when "00010" => --B
								Reg1  (3 downto 0)<= "1111";
								Reg2  (3 downto 0)<= "1111";
								ALUOP (3 downto 0)<= "0000";
								ALUSRC				<= '1';
								RegDst(3 downto 0)<= "1111";
								
								immediate	(10 downto 0)<= PCin(10 downto 0);
								immediate_n	(2 downto 0) <= "100";
								immediate_arith			 <= '1';
								
								MemRead	<= '0';
								MemWrite	<= '0';
								MemToReg	<= "10";
								RegWrite <= '0';
								
							when "00100" => --BEQZ
								Reg1	(3)			<= '0';
								Reg1  (2 downto 0)<= PCin(10 downto 8);
								Reg2  (3 downto 0)<= "1111";
								ALUOP (3 downto 0)<= "0000";
								ALUSRC				<= '1';
								RegDst(3 downto 0)<= "1111";
								
								immediate	(7 downto 0)<= PCin(7 downto 0);
								immediate_n	(2 downto 0)<= "011";
								immediate_arith			<= '1';
								
								MemRead	<= '0';
								MemWrite	<= '0';
								MemToReg	<= "10";
								RegWrite <= '0';
								
							when "01110" => --CMPI
								Reg1	(3)			<= '0';
								Reg1  (2 downto 0)<= PCin(10 downto 8);
								Reg2  (3 downto 0)<= "1111";
								ALUOP (3 downto 0)<= "1001";
								ALUSRC				<= '1';
								RegDst(3 downto 0)<= "1010";
								
								immediate	(7 downto 0)<= PCin(7 downto 0);
								immediate_n	(2 downto 0)<= "011";
								immediate_arith			<= '1';
								
								MemRead	<= '0';
								MemWrite	<= '0';
								MemToReg	<= "01";
								RegWrite <= '1';
								
							when "01101" => --LI
								Reg1  (3 downto 0)<= "1100";
								Reg2  (3 downto 0)<= "1111";
								ALUOP (3 downto 0)<= "0001";
								ALUSRC				<= '1';
								RegDst(3)			<= '0';
								RegDst(2 downto 0)<= PCin(10 downto 8);
								
								immediate	(7 downto 0)<= PCin(7 downto 0);
								immediate_n	(2 downto 0)<= "011";
								immediate_arith			<= '0';
								
								MemRead	<= '0';
								MemWrite	<= '0';
								MemToReg	<= "01";
								RegWrite <= '1';
								
							when "10011" => --LW
								Reg1	(3)			<= '0';
								Reg1  (2 downto 0)<= PCin(10 downto 8);
								Reg2  (3 downto 0)<= "1111";
								ALUOP (3 downto 0)<= "0001";
								ALUSRC				<= '1';
								RegDst(3)			<= '0';
								RegDst(2 downto 0)<= PCin(7 downto 5);
								
								immediate	(4 downto 0)<= PCin(4 downto 0);
								immediate_n	(2 downto 0)<= "010";
								immediate_arith			<= '1';
								
								MemRead	<= '1';
								MemWrite	<= '0';
								MemToReg	<= "00";
								RegWrite <= '1';
								
							when "10010" => --LW_SP
								Reg1  (3 downto 0)<= "1000";
								Reg2  (3 downto 0)<= "1111";
								ALUOP (3 downto 0)<= "0001";
								ALUSRC				<= '1';
								RegDst(3)			<= '0';
								RegDst(2 downto 0)<= PCin(10 downto 8);
								
								immediate	(7 downto 0)<= PCin(7 downto 0);
								immediate_n	(2 downto 0)<= "011";
								immediate_arith			<= '1';
								
								MemRead	<= '1';
								MemWrite	<= '0';
								MemToReg	<= "00";
								RegWrite <= '1';
								
							when "11011" => --SW
								Reg1	(3)			<= '0';
								Reg1  (2 downto 0)<= PCin(10 downto 8);
								Reg2	(3)			<= '0';
								Reg2  (2 downto 0)<= PCin(7 downto 5);
								ALUOP (3 downto 0)<= "0001";
								ALUSRC				<= '1';
								RegDst(3 downto 0)<= "1111";
								
								immediate	(4 downto 0)<= PCin(4 downto 0);
								immediate_n	(2 downto 0)<= "010";
								immediate_arith			<= '1';
								
								MemRead	<= '0';
								MemWrite	<= '1';
								MemToReg	<= "10";
								RegWrite <= '0';
								
							when "11010" => --SW_SP
								Reg1  (3 downto 0)<= "1000";
								Reg2	(3)			<= '0';
								Reg2  (2 downto 0)<= PCin(10 downto 8);
								ALUOP (3 downto 0)<= "0001";
								ALUSRC				<= '1';
								RegDst(3 downto 0)<= "1111";
								
								immediate	(7 downto 0)<= PCin(7 downto 0);
								immediate_n	(2 downto 0)<= "011";
								immediate_arith			<= '1';
								
								MemRead	<= '0';
								MemWrite	<= '1';
								MemToReg	<= "10";
								RegWrite <= '0';
								
							when "01111" => --MOVE
								Reg1  (3 downto 0)<= "1111";
								Reg2	(3)			<= '0';
								Reg2  (2 downto 0)<= PCin(7 downto 5);
								ALUOP (3 downto 0)<= "0000";
								ALUSRC				<= '1';
								RegDst(3)			<= '0';
								RegDst(2 downto 0)<= PCin(10 downto 8);
								
								immediate	(7 downto 0)<= "00000000";
								immediate_n	(2 downto 0)<= "011";
								immediate_arith			<= '1';
								
								MemRead	<= '0';
								MemWrite	<= '0';
								MemToReg	<= "10";
								RegWrite <= '1';
								
							when "00001" => --NOP
								Reg1  (3 downto 0)<= "1111";
								Reg2  (3 downto 0)<= "1111";
								ALUOP (3 downto 0)<= "0000";
								ALUSRC				<= '1';
								RegDst(3 downto 0)<= "1111";
								
								immediate	(7 downto 0)<= "00000000";
								immediate_n	(2 downto 0)<= "011";
								immediate_arith			<= '1';
								
								MemRead	<= '0';
								MemWrite	<= '0';
								MemToReg	<= "10";
								RegWrite <= '0';
								
							when "01100" => --ADDSP BTEQZ MTSP
								case control_first8 is
									when "01100011" => --ADDSP
										Reg1  (3 downto 0)<= "1000";
										Reg2  (3 downto 0)<= "1111";
										ALUOP (3 downto 0)<= "0001";
										ALUSRC				<= '1';
										RegDst(3 downto 0)<= "1000";
										
										immediate	(7 downto 0)<= PCin(7 downto 0);
										immediate_n	(2 downto 0)<= "011";
										immediate_arith			<= '1';
										
										MemRead	<= '0';
										MemWrite	<= '0';
										MemToReg	<= "01";
										RegWrite <= '1';
										
									when "01100000" => --BTEQZ
										Reg1  (3 downto 0)<= "1010";
										Reg2  (3 downto 0)<= "1111";
										ALUOP (3 downto 0)<= "0000";
										ALUSRC				<= '1';
										RegDst(3 downto 0)<= "1111";
										
										immediate	(7 downto 0)<= Pcin(7 downto 0);
										immediate_n	(2 downto 0)<= "011";
										immediate_arith			<= '1';
										
										MemRead	<= '0';
										MemWrite	<= '0';
										MemToReg	<= "10";
										RegWrite <= '0';
										
									when "01100100" => --MTSP
										Reg1  (3 downto 0)<= "1111";
										Reg2	(3)			<= '0';
										Reg2  (2 downto 0)<= PCin(7 downto 5);
										ALUOP (3 downto 0)<= "0000";
										ALUSRC				<= '1';
										RegDst(3 downto 0)<= "1000";
										
										immediate	(7 downto 0)<= "00000000";
										immediate_n	(2 downto 0)<= "011";
										immediate_arith			<= '1';
										
										MemRead	<= '0';
										MemWrite	<= '0';
										MemToReg	<= "10";
										RegWrite <= '1';
										
									when others => --error
								end case;
								
							when "11100" => --ADDU SUBU
								Reg1	(3)			<= '0';
								Reg1  (2 downto 0)<= PCin(10 downto 8);
								Reg2	(3)			<= '0';
								Reg2  (2 downto 0)<= PCin(7 downto 5);
								ALUSRC				<= '0';
								RegDst(3)			<= '0';
								RegDst(2 downto 0)<= PCin(4 downto 2);
								
								immediate	(7 downto 0)<= "00000000";
								immediate_n	(2 downto 0)<= "011";
								immediate_arith			<= '1';
								
								MemRead	<= '0';
								MemWrite	<= '0';
								MemToReg	<= "01";
								RegWrite <= '1';
								case control_last2 is
									when "01" => --ADDU
										ALUOP	(3 downto 0)<= "0001";
										
									when "11" => --SUBU
										ALUOP (3 downto 0)<= "0011";
										
									when others => --error
								end case;
								
							when "11101" => --AND CMP JR MFPC OR SLT
								case control_last5 is
									when "01100" => -- AND
										Reg1	(3)			<= '0';
										Reg1  (2 downto 0)<= PCin(10 downto 8);
										Reg2	(3)			<= '0';
										Reg2  (2 downto 0)<= PCin(7 downto 5);
										ALUOP					<= "0010";
										ALUSRC				<= '0';
										RegDst(3)			<= '0';
										RegDst(2 downto 0)<= PCin(10 downto 8);
										
										immediate	(7 downto 0)<= "00000000";
										immediate_n	(2 downto 0)<= "011";
										immediate_arith			<= '1';
										
										MemRead	<= '0';
										MemWrite	<= '0';
										MemToReg	<= "01";
										RegWrite <= '1';
									
									when "01010" => --CMP
										Reg1	(3)			<= '0';
										Reg1  (2 downto 0)<= PCin(10 downto 8);
										Reg2	(3)			<= '0';
										Reg2  (2 downto 0)<= PCin(7 downto 5);
										ALUOP					<= "1001";
										ALUSRC				<= '0';
										RegDst(3 downto 0)<= "1010";
										
										immediate	(7 downto 0)<= "00000000";
										immediate_n	(2 downto 0)<= "011";
										immediate_arith			<= '1';
										
										MemRead	<= '0';
										MemWrite	<= '0';
										MemToReg	<= "01";
										RegWrite <= '1';
										
									when "01101" => --OR
										Reg1	(3)			<= '0';
										Reg1  (2 downto 0)<= PCin(10 downto 8);
										Reg2	(3)			<= '0';
										Reg2  (2 downto 0)<= PCin(7 downto 5);
										ALUOP					<= "0100";
										ALUSRC				<= '0';
										RegDst(3)			<= '0';
										RegDst(2 downto 0)<= PCin(10 downto 8);
										
										immediate	(7 downto 0)<= "00000000";
										immediate_n	(2 downto 0)<= "011";
										immediate_arith			<= '1';
										
										MemRead	<= '0';
										MemWrite	<= '0';
										MemToReg	<= "01";
										RegWrite <= '1';
										
									when "00010" => --SLT
										Reg1	(3)			<= '0';
										Reg1  (2 downto 0)<= PCin(10 downto 8);
										Reg2	(3)			<= '0';
										Reg2  (2 downto 0)<= PCin(7 downto 5);
										ALUOP					<= "0110";
										ALUSRC				<= '0';
										RegDst(3 downto 0)<= "1010";
										
										immediate	(7 downto 0)<= "00000000";
										immediate_n	(2 downto 0)<= "011";
										immediate_arith			<= '1';
										
										MemRead	<= '0';
										MemWrite	<= '0';
										MemToReg	<= "01";
										RegWrite <= '1';
										
									when "00000" => --JR MFPC
										case control_last8 is
											when "00000000" => --JR
												Reg1	(3)			<= '0';
												Reg1  (2 downto 0)<= PCin(10 downto 8);
												Reg2  (3 downto 0)<= "1111";
												ALUOP					<= "0000";
												ALUSRC				<= '1';
												RegDst(3 downto 0)<= "1111";
												
												immediate	(7 downto 0)<= "00000000";
												immediate_n	(2 downto 0)<= "011";
												immediate_arith			<= '1';
												
												MemRead	<= '0';
												MemWrite	<= '0';
												MemToReg	<= "10";
												RegWrite <= '0';
												
											when "01000000" => --MFPC
												Reg1  (3 downto 0)<= "1111";
												Reg2  (3 downto 0)<= "1001";
												ALUOP					<= "0000";
												ALUSRC				<= '1';
												RegDst(3)			<= '0';
												RegDst(2 downto 0)<= PCin(10 downto 8);
												
												immediate	(7 downto 0)<= "00000000";
												immediate_n	(2 downto 0)<= "011";
												immediate_arith			<= '1';
												
												MemRead	<= '0';
												MemWrite	<= '0';
												MemToReg	<= "10";
												RegWrite <= '1';
												
											when others => --error
										end case;
										
									when others => --error
								end case;
								
							when "11110" => -- MFIH MTIH
								case control_last2 is
									when "00" => -- MFIH
										Reg1  (3 downto 0)<= "1111";
										Reg2  (3 downto 0)<= "1011";
										ALUOP					<= "0000";
										ALUSRC				<= '1';
										RegDst(3)			<= '0';
										RegDst(2 downto 0)<= PCin(10 downto 8);
										
										immediate	(7 downto 0)<= "00000000";
										immediate_n	(2 downto 0)<= "011";
										immediate_arith			<= '1';
										
										MemRead	<= '0';
										MemWrite	<= '0';
										MemToReg	<= "10";
										RegWrite <= '1';
										
									when "01" => -- MTIH
										Reg1  (3 downto 0)<= "1111";
										Reg2	(3)			<= '0';
										Reg2  (2 downto 0)<= PCin(10 downto 8);
										ALUOP					<= "0000";
										ALUSRC				<= '1';
										RegDst(3 downto 0)<= "1011";
										
										immediate	(7 downto 0)<= "00000000";
										immediate_n	(2 downto 0)<= "011";
										immediate_arith			<= '1';
										
										MemRead	<= '0';
										MemWrite	<= '0';
										MemToReg	<= "10";
										RegWrite <= '1';
										
									when others => --error
								end case;
								
							when "00110" => -- SLL SRA SRL
								Reg1	(3)			<= '0';
								Reg1  (2 downto 0)<= PCin(7 downto 5);
								Reg2  (3 downto 0)<= "1111";
								ALUSRC				<= '1';
								RegDst(3)			<= '0';
								RegDst(2 downto 0)<= PCin(10 downto 8);
								
								immediate	(2 downto 0)<= PCin(4 downto 2);
								immediate_n	(2 downto 0)<= "000";
								immediate_arith			<= '0';
								
								MemRead	<= '0';
								MemWrite	<= '0';
								MemToReg	<= "01";
								RegWrite <= '1';
								case control_last2 is
									when "00" =>
										ALUOP		<= "0101";
									when "11" =>
										ALUOP		<= "0111";
									when "10" =>
										ALUOP		<= "1000";
									when others => --error
								end case;
							
							when others => --error
						end case;
						
						current_state <= s1;
					when s1 =>
						current_state <= s2;
					when s2 =>
						current_state <= s0;
				end case;
			end if;
		end if;
	end process;


end Behavioral;

