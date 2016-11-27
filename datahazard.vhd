library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datahazard is
    Port ( 	IDEXMemRead : in STD_LOGIC;
           	IDEXRegDst : in STD_LOGIC_VECTOR(3 downto 0);
           	IFIDr1 : in  STD_LOGIC_VECTOR (3 downto 0);--FD.R1
           	IFIDr2 : in  STD_LOGIC_VECTOR (3 downto 0);--FD.R2
           	isBubble : out  STD_LOGIC
           	);
end datahazard;

architecture Behavioral of datahazard is

begin

process 
begin 
	if (IDEXMemRead='1' and (IFIDr1=IDEXRegDst or IFIDr2=IDEXRegDst)) then
		isBubble = '1';
	else
		isBubble = '0';
	end if;
end process;

end Behavioral;
