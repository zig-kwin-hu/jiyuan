library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity PCchoose is
	port(	
			PCsrc : in STD_LOGIC_VECTOR(1 downto 0);
			PCadd1 : in STD_LOGIC_VECTOR(15 downto 0);
			PCjump : in STD_LOGIC_VECTOR(15 downto 0);
			PCout : out STD_LOGIC_VECTOR(15 downto 0)
		);
end PCchoose;

architecture Behavior of PCchoose is
begin
process
begin
	if(PCsrc = "11") then
		PCout <= PCjump;
	else 
		PCout <= PCadd1;
	end if;
end process;
end Behavior;