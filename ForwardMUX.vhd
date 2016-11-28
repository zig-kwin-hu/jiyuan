library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ForwardMUX is
    Port ( 	data1 : in  STD_LOGIC_VECTOR (15 downto 0);--Reg
           	data2 : in  STD_LOGIC_VECTOR (15 downto 0);--EX.re_Alu
           	data3 :	in  STD_LOGIC_VECTOR (15 downto 0);--MEM.re_Alu/re_Mem
			forward: in STD_LOGIC_VECTOR (1 downto 0);           	
			Aludata : out  STD_LOGIC_VECTOR (15 downto 0));
end ForwardMUX;

architecture Behavioral of ForwardMUX is

begin
process 
begin
	if(forward="00") then
		Aludata <= data1;
	elsif (forward="10") then
		Aludata <= data2;
	elsif (forward="01") then
		Aludata <= data3;
	end if;
end process;

end Behavioral;
