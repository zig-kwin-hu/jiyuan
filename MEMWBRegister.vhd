library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity MEMWBRegister is
	port(
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		MemToRegin : in STD_LOGIC_VECTOR(1 downto 0);
		MemToRegout : out STD_LOGIC_VECTOR(1 downto 0);
		RegWritein : in STD_LOGIC;
		RegWriteout : out STD_LOGIC;
		MemResultin : in STD_LOGIC_VECTOR(15 downto 0);
		MemResultout : out STD_LOGIC_VECTOR(15 downto 0);
		ALUResultin : in STD_LOGIC_VECTOR(15 downto 0);
		ALUResultout : out STD_LOGIC_VECTOR(15 downto 0);
		RegResultin : in STD_LOGIC_VECTOR(15 downto 0);
		RegResultout : out STD_LOGIC_VECTOR(15 downto 0 );
		RegDestin : in STD_LOGIC_VECTOR(3 downto 0);
		RegDestout : out STD_LOGIC_VECTOR(3 downto 0)
	);
end MEMWBRegister;

architecture Behavior of MEMWBRegister is 

signal MemToReglocal: STD_LOGIC_VECTOR(2 downto 0);
signal RegWritelocal: STD_LOGIC;
signal MemResultlocal: STD_LOGIC_VECTOR(15 downto 0);
signal ALUResultlocal: STD_LOGIC_VECTOR(15 downto 0);
signal RegResultlocal: STD_LOGIC_VECTOR(15 downto 0);
signal RegDestlocal: STD_LOGIC_VECTOR(3 downto 0);

begin
MemToRegout <= MemToReglocal;
RegWriteout <= RegWritelocal;
MemResultout <= MemResultlocal;
ALUResultout <= ALUResultlocal;
RegResultout <= RegResultlocal;
RegDestout <= RegDestlocal;

process(clk)
begin
	if(rst='0') then
		MemToReglocal <= "00";
		RegWritelocal <= '0';
		MemResultlocal <= "0000000000000000";
		RegResultlocal <= "0000000000000000";
		ALUResultlocal <= "000000000000";
	elsif(clk'event and clk = '1') then
		MemToReglocal <= MemToRegin;
		RegWritelocal <= RegWritein;
		MemResultlocal <= MemResultin;
		RegResultlocal <= RegResultin;
		ALUResultlocal <= ALUResultin;
		RegDestlocal <= RegDestin;
	end if;
end process;

end Behavior;