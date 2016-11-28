library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity IO is 
	port(
		rst : in STD_LOGIC;
		clk : in STD_LOGIC;
		address : in STD_LOGIC_VECTOR(15 downto 0);
		data : in STD_LOGIC_VECTOR(15 downto 0);
		MemWrite : in STD_LOGIC;
		MemRead : in STD_LOGIC;
		ram1_en 		: out std_logic;
		ram1_oe			: out std_logic;
		ram1_we			: out std_logic;
		addressram1 : out STD_LOGIC_VECTOR(17 downto 0);
		dataram1 : inout STD_LOGIC_VECTOR(15 downto 0);
		ram2_en 		: out std_logic;
		ram2_oe			: out std_logic;
		ram2_we			: out std_logic;
		addressram2 : out STD_LOGIC_VECTOR(17 downto 0);
		dataram2 : inout STD_LOGIC_VECTOR(15 downto 0);
		dataout : out STD_LOGIC_VECTOR(15 downto 0);
		bubble : in STD_LOGIC
		);
end IO;

architecture Behavior of IO is
signal state : STD_LOGIC_VECTOR(1 downto 0) := "00";

begin

process
begin
	if(address <= x"FFFF" and address >= x"C000") then
		dataout <= dataram1;
	elsif address <= x"7FFF" and address >= x"4000" then
		dataout <= dataram2;
	end if;
end process;

process(clk)
begin
	if (rst = '0') then
		ram1_en <= '1';
		ram1_we <= '1';
		ram2_oe <= '1';
		ram2_en <= '1';
		ram2_we <= '1';
		ram2_oe <= '1';
		--PCbubble <= '0';
		state <= "00";
	elsif (clk'event and clk = '1') then
		if(state = "00") then
			ram1_we <= '1';
			ram1_oe <= '1';
			ram2_we <= '1';
			ram2_oe <= '1';
			state <= "01";
		else			
			if(MemRead = '1') then --è¯
				if(address <= x"FFFF" and address >= x"C000") then --è¯	
					case state is
						when "01" =>
							addressram1(15 downto 0) <= address;
							addressram1(17 downto 16) <= "00";
							dataram1 <= "ZZZZZZZZZZZZZZZZ";
							ram1_en <= '0';
							ram1_we <= '1';
							ram1_oe <= '1';
							state <= "10";
						when "10" =>
							ram1_oe <= '0';
							state <= "00";
						when others =>
							state<="00";
					end case;
				elsif address <= x"7FFF" and address >= x"4000" then
					if bubble = '1' then
						case state is
							when "01" =>
								--PCbubble <= '1';
								addressram2(15 downto 0) <= address;
								addressram2(17 downto 16) <= "00";
								dataram2 <= "ZZZZZZZZZZZZZZZZ";
								ram2_en <= '0';
								ram2_we <= '1';
								ram2_oe <= '1';
								state <= "10";
							when "10" =>
								ram2_oe <= '0';
								state <= "00";
							when others =>
								state<="00";
						end case;
					end if;
				end if;
			elsif (MemWrite = '1') then
				if(address <= x"FFFF" and address >= x"C000") then --è¯	
					case state is
						when "01" =>
							addressram1(15 downto 0) <= address;
							addressram1(17 downto 16) <= "00";
							dataram1 <= data;
							ram1_en <= '0';
							ram2_we <= '1';
							ram2_oe <= '1';
							state <= "10";
						when "10" =>
							ram1_we <= '0';
							state <= "00";
						when others =>
							state<="00";
					end case;
				elsif address <= x"7FFF" and address >= x"4000" then
					if bubble = '1' then
					case state is
						when "01" =>
							addressram2(15 downto 0) <= address;
							addressram2(17 downto 16) <= "00";
							dataram2 <= "ZZZZZZZZZZZZZZZZ";
							ram2_en <= '0';
							state <= "10";
						when "10" =>
							ram2_oe <= '0';
							state <= "00";
						when others =>
							state<="00";
					end case;
					end if;
				end if;
			end if;
		end if;			
	end if;
end process;
end Behavior;