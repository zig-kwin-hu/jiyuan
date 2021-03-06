ibrary IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Forward is
    Port ( 	MEMWBRegWrite : in  STD_LOGIC;
           	EXMEMRegWrite : in  STD_LOGIC;
           	EXMEMrd : in  STD_LOGIC_VECTOR (3 downto 0);--EM.RegDst
           	MEMWBrd : in  STD_LOGIC_VECTOR (3 downto 0);--MW.RegDst
           	IDEXrx : in  STD_LOGIC_VECTOR (3 downto 0);--DE.R1
           	IDEXry : in  STD_LOGIC_VECTOR (3 downto 0);--DE.R2
           	ForwardA : out STD_LOGIC_VECTOR(1 downto 0);
           	ForwardB : out STD_LOGIC_VECTOR(1 downto 0);

           	ForwardC : out STD_LOGIC_VECTOR(1 downto 0);--00-Reg,01-Mem.Re,10-WB.ToReg

            IsJROrder : in STD_LOGIC;
           	IsJumpOrder : in STD_LOGIC_VECTOR(1 downto);
           	IFIDR1 : in STD_LOGIC_VECTOR(3 downto 0);
            EXMEMMemRead : in STD_LOGIC
           	);
end Forward;

architecture Behavioral of Forward is

begin

process 
begin 
	if (MEMWBRegWrite='1' and MEMWBrd/="1111" and not(EXMEMRegWrite='1' and EXMEMrd/="1111" and EXMEMrd=IDEXrx) and MEMWBrd=IDEXrx) then
		ForwardA<="01";
	elsif (EXMEMRegWrite='1' and EXMEMrd/="1111" and EXMEMrd=IDEXrx) then
		ForwardA<="10";
	else
		ForwardA<="00";
	end if;
			
	if (MEMWBRegWrite='1' and MEMWBrd/="1111" and not(EXMEMRegWrite='1' and EXMEMrd/="1111" and EXMEMrd=IDEXry) and MEMWBrd=IDEXry) then
		ForwardB<="01";
	elsif (EXMEMRegWrite='1' and EXMEMrd/="1111" and EXMEMrd=IDEXry) then
		ForwardB<="10";
	else
		ForwardB<="00";
	end if;

  if (IsJROrder='1' or IsJumpOrder="01" or IsJumpOrder="10") then 
    if (EXMEMRegWrite='1' and EXMEMMemRead='0' and EXMEMrd=IFIDR1)
      ForwardC<="01"
    else
      ForwardC<="00"
    end if;
  else
      ForwardC<="00";
  end if;

end process;

end Behavioral;