library IEEE;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Alu is
    Port ( 	op: in STD_LOGIC_VECTOR (3 downto 0);
    		A,B: in  STD_LOGIC_VECTOR (15 downto 0);
			--led : out  STD_LOGIC_VECTOR (15 downto 0);
			re: out  STD_LOGIC_VECTOR (15 downto 0)
			);
end Alu;

architecture Behavioral of Alu is
	shared variable tem:std_logic_vector(15 downto 0):="0000000000000000";
begin
	process
	begin
		case op is
			when "0000" =>
				re<="0000000000000000";
			when "0001" =>
				re<=A + B;
			when "0010" =>
				re<=A AND B;
			when "0011" =>
				re<=A - B;
			when "0100" =>
				re<=A OR B;
			when "0101" =>
				tem:=A(15 downto 0);
				if (B="0000000000000000") then
					re(15 downto 0)<=To_StdLogicVector(To_bitvector(tem) SLL 8);
				else
					re(15 downto 0)<=To_StdLogicVector(To_bitvector(tem) SLL conv_integer(B));
				end if;
			when "0110" =>
				if (A<B) then
				   re<="0000000000000001";
				else
				   re<="0000000000000000";
				end if;
			when "0111" =>
				tem:=A(15 downto 0);
				if (B="0000000000000000") then
					re(15 downto 0)<=To_StdLogicVector(To_bitvector(tem) SRA 8);
				else
					re(15 downto 0)<=To_StdLogicVector(To_bitvector(tem) SRA conv_integer(B));
				end if;
			when "1000" =>
				tem:=A(15 downto 0);
				if (B="0000000000000000") then
					re(15 downto 0)<=To_StdLogicVector(To_bitvector(tem) SRL 8);
				else
					re(15 downto 0)<=To_StdLogicVector(To_bitvector(tem) SRL conv_integer(B));
				end if;		
			when "1001" =>   
				if (A=B) then
				   re<="0000000000000000";
				else
				   re<="0000000000000001";
				end if;
			when others=>
		end case;
	end process;
	
end Behavioral;

