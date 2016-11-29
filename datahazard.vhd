library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datahazard is
    Port (  IDEXMemRead : in STD_LOGIC;
            IDEXRegDst : in STD_LOGIC_VECTOR(3 downto 0);
            IFIDr1 : in  STD_LOGIC_VECTOR (3 downto 0);--FD.R1
            IFIDr2 : in  STD_LOGIC_VECTOR (3 downto 0);--FD.R2
            IsJROrderin : in STD_LOGIC;
            IsJumpOrder : in STD_LOGIC_VECTOR(1 downto 0);
            EXMEMMEMRead : in STD_LOGIC;
            EXMEMRegDst : in STD_LOGIC_VECTOR(3 downto 0);
            isBubble : out  STD_LOGIC
            );
end datahazard;

architecture Behavioral of datahazard is

begin

process 
begin
  if (IsJROrderin='1' or IsJumpOrder="10" or IsJumpOrder="01") then 
    if (IDEXRegDst=IFIDr1) then
      isBubble = '1';
    elsif (EXMEMMEMRead='1' and EXMEMRegDst=IFIDr1) then
      isBubble = '1';
    else
      is isBubble = '0';
    end if;
  else 
   if (IDEXMemRead='1' and (IFIDr1=IDEXRegDst or IFIDr2=IDEXRegDst)) then
    isBubble = '1';
   else
    isBubble = '0';
   end if;
  end if;
end process;

end Behavioral;