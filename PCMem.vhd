library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity PCMem is 
port(
		rst : in STD_LOGIC;
		clk : in STD_LOGIC;
		PCaddress : in STD_LOGIC_VECTOR(15 downto 0);
		ram2address : out STD_LOGIC_VECTOR(17 downto 0);
		ram2data : inout STD_LOGIC_VECTOR(15 downto 0);
		ram2_en : out std_logic;
		ram2_oe	: out std_logic;
		ram2_we	: out std_logic;
		PCout : out STD_LOGIC_VECTOR(15 downto 0);
		bubble : in STD_LOGIC
	);
end PCMem;

architecture Behavior of PCMem is
signal state : STD_LOGIC_VECTOR(1 downto 0) := "00";

begin
ram2address(17 downto 16) <= "00";
process
begin
if(bubble = '0') then
	PCout <= ram2data;
else
	PCout <= "0000100000000000";
end if;
end process;
process(clk)
	begin
	if(rst = '0') then
		ram2_en <= '1';
		ram2_we <= '1';
		ram2_oe <= '1';
		state <="00";
	elsif clk'event and clk = '1' then
		case state is
			when "00" =>
				state <= "01";
			when "01" =>
				if(bubble = '0') then
					ram2_en <= '0';
					ram2_we <= '1';
					ram2_oe <= '1';
					ram2address(15 downto 0) <= PCaddress;
					ram2data <= "ZZZZZZZZZZZZZZZZ";
				end if;
				state <= "10";
			when "10" =>
				if(bubble = '0') then
					ram2_oe <= '0';
				end if;
				state <= "00";
		end case;	
	end if;
end process;
end Behavior;