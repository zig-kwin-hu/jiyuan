library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AluSrcMUX is
    Port ( data1 : in  STD_LOGIC_VECTOR (15 downto 0);--data2 from register
           data2 : in  STD_LOGIC_VECTOR (15 downto 0);--immediate
           AluSrc : in  STD_LOGIC;
           Aludata : out  STD_LOGIC_VECTOR (15 downto 0));
end AluSrcMUX;

architecture Behavioral of AluSrcMUX is

begin
process 
begin
	case AluSrc is
	when "0"=>--0 for data2 from register
		Aludata1<=data1;
	when "1"=>--1 for immediate
		Aludata1<=data2;
	when others=>
	end case;
end process;

end Behavioral;

