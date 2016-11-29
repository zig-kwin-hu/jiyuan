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
	Signal state:STD_LOGIC_VECTOR(1 downto 0) := "00";
begin
	Commandout<=localCommand;
	PCout<=localPC;

	process(clk,rst)
	begin
		if(rst='0')then
			localCommand<="0000000000000000";
			localPC<="0000000000000000";
			state<="00";
		elsif(clk'event and clk='1') then
			case (state) is
				when "00"=>
					if(IsBubble='0') then
					localCommand<=Commandin;
					localPC<=PCin;
					end if;	
					state<="01";
				when "01"=>
					state<="10";
				when "10"=>
					state<="00";
				when others =>
					state <= "00";
			end case;
		end if;
	end process;
end Behavioral;

