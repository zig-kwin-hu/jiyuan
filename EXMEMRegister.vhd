library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EXMEMRegister is 
	port(	clk : in STD_LOGIC;
			rst : in STD_LOGIC;
			MemReadin : in STD_LOGIC;
			MemReadout : out STD_LOGIC;
			MemWritein : in STD_LOGIC;
			MemWriteout : out STD_LOGIC;
			MemToRegin : in STD_LOGIC_Vector(1 downto 0);
			MemToRegout : out STD_LOGIC_Vector(1 downto 0);
			RegWritein : in STD_LOGIC;
			RegWriteout : out STD_LOGIC;
			ALUResultin : in STD_LOGIC_Vector(15 downto 0);
			ALUResultout : out STD_LOGIC_Vector(15 downto 0);
			RegResultin : in STD_LOGIC_Vector(15 downto 0);
			RegResultout : out STD_LOGIC_Vector(15 downto 0); 
			RegDestin : in STD_LOGIC_Vector(3 downto 0);
			RegDestout : out STD_LOGIC_Vector(3 downto 0)
		);
end EXMEMRegister;

architecture Behavior of EXMEMRegister is

signal MemReadlocal : STD_LOGIC;
signal MemWritelocal : STD_LOGIC;
signal MemToReglocal : STD_LOGIC_Vector(1 downto 0); 
signal RegWritelocal : STD_LOGIC;
signal ALUResultlocal : STD_LOGIC_Vector(15 downto 0);
signal RegResultlocal : STD_LOGIC_Vector(15 downto 0);
signal RegDestlocal : STD_LOGIC_Vector(3 downto 0);

begin
MemReadout <= MemReadlocal;
MemWriteout <= MemWritelocal;
MemToRegout <= MemToReglocal;
RegWriteout <= RegWritelocal;
ALUResultout <= ALUResultlocal;
RegResultout <= RegResultlocal;
RegDestout <= RegDestlocal;

process(clk)
begin
	if(rst = '1') then
		MemReadlocal <= '0';
		MemWritelocal <= '0';
		MemToReglocal <= "00";
		RegWritelocal <= '0';
		ALUResultlocal <= "0000000000000000";
		RegResultlocal <= "0000000000000000";
		RegDestlocal <= "0000000000000000";
	end if;
	if(clk'event and clk = '1') then
		MemReadlocal <= MemReadin;
		MemWritelocal <= MemWritein;
		MemToReglocal <= MemToRegin;
		RegWritelocal <= RegWritein;
		ALUResultlocal <= ALUResultin;
		RegResultlocal <= RegResultin;
		RegDestlocal <= RegDestin;
	end if;
end process;
end Behavior;