library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FDRegister is
    Port ( 	IsBubble : in  STD_LOGIC;
			clk: in STD_LOGIC;
			rst: in STD_LOGIC;
           	PCin : in  STD_LOGIC_VECTOR (15 downto 0);
			PCout : out STD_LOGIC_VECTOR (15 downto 0);
           	Commandin : in  STD_LOGIC_VECTOR (15 downto 0);
           	Commandout : inout  STD_LOGIC_VECTOR (15 downto 0)
           	);
end FDRegister;

architecture Behavioral of FDRegister is
Signal localPC:STD_LOGIC_VECTOR (15 downto 0);
Signal localCommand:STD_LOGIC_VECTOR (15 downto 0);
begin
	Commandout<=localCommand;
	PCout<=localPC;

process(clk)
begin
	if(rst='0')then
		localCommand<="0000000000000000";
		localPC<="0000000000000000";
	elsif(clk'event and clk='1') then
			if(IsBubble='0') then
			localCommand<=Commandin;
			localPC<=PCin;
			end if;
	end if;
end process;
end Behavioral;

