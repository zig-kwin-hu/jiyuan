library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MWRegister is
	port(	MEMWBWrite:in STD_LOGIC;
			  clk : in STD_LOGIC;
			  rst : in STD_LOGIC;
			  Regin: in STD_LOGIC_VECTOR(3 downto 0);
			  Regout: out STD_LOGIC_VECTOR(3 downto 0);
			  ALUresultin: in STD_LOGIC_VECTOR(15 downto 0);
			  ALUresultout: out STD_LOGIC_VECTOR(15 downto 0);
			  Memin: in STD_LOGIC_VECTOR(15 downto 0);
			  Memout: out STD_LOGIC_VECTOR(15 downto 0);
			  data2in : in STD_LOGIC_VECTOR (15 downto 0);
			  data2out : out STD_LOGIC_VECTOR (15 downto 0);
			  --W
			  MemtoRegin : in STD_LOGIC;
			  RegWritein : in STD_LOGIC;
			  MemtoRegout : out STD_LOGIC; 
			  RegWriteout : out STD_LOGIC
	);
end MWRegister;

architecture Behavioral of MWRegister is

signal localReg: STD_LOGIC_VECTOR(3 downto 0);
signal localALUresult: STD_LOGIC_VECTOR(15 downto 0);
signal localMem: STD_LOGIC_VECTOR(15 downto 0);
signal localMemtoReg: STD_LOGIC;
signal localRegWrite: STD_LOGIC;
signal localdata2: STD_LOGIC_VECTOR(15 downto 0);

begin

Regout<=localReg;
ALUresultout<=localALUresult;
Memout<=localMem;
MemtoRegout<=localMemtoReg;
RegWriteout<=localRegWrite;
data2out<=localdata2

process(clk)
begin
	if(rst='0') then
		localReg<="0000";
		localALUresult<="0000000000000000";
		localMem<="0000000000000000";
		localMemtoReg<='0';
		localRegWrite<='0';
		localdata2<="0000000000000000";
	elsif(clk'event and clk='1') then
		if(MEMWBWrite='0') then
		localReg<=Regin;
		localALUresult<=ALUresultin;
		localMem<=Memin;
		localMemtoReg<=MemtoRegin;
		localRegWrite<=RegWritein;
		localdata2<=data2in
		end if;
	end if;
end process;

end Behavioral;