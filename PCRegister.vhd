library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity PCRegister is
	port(
			rst : in STD_LOGIC;
			clk : in STD_LOGIC;
			PCin : in STD_LOGIC_VECTOR(15 downto 0);
			PCout : out STD_LOGIC_VECTOR(15 downto 0);
			bubble : in STD_LOGIC
		);
end PCRegister;

architecture Behavior of PCRegister is
signal PClocal : STD_LOGIC_VECTOR(15 downto 0) := "1111111111111111";
signal state : STD_LOGIC_VECTOR(1 downto 0) := "00";
begin

PCout <= PClocal;
process (clk)
begin
if(rst = '0') then
	state <= "00";
elsif clk'event and clk = '1' then
	case state is
		when "00" =>
			if(bubble = '0')then
				PClocal <= PCin;
			end if;
			state <= "01";
		when "01" =>
			state <= "10";
		when "10" =>
			state <= "00";
		when others =>
			state <= "00";
	end case;
end if;
end process;

end Behavior;