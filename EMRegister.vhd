library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EMRegister is
	port(	EXMEMWrite : in  STD_LOGIC;--stall signal?
			clk : in STD_LOGIC;
			rst : in STD_LOGIC;
			Regin: in STD_LOGIC_VECTOR(3 downto 0);
			Regout: out STD_LOGIC_VECTOR(3 downto 0);
			ALUresultin: in STD_LOGIC_VECTOR(15 downto 0);
			ALUresultout: out STD_LOGIC_VECTOR(15 downto 0);
			data2in : in STD_LOGIC_VECTOR (15 downto 0);
			data2out : out STD_LOGIC_VECTOR (15 downto 0);
			--M
			MemWritein : in STD_LOGIC;
			MemWriteout : out STD_LOGIC;
			MemReadin : in STD_LOGIC;
			MemReadout : out STD_LOGIC;
			--W
			MemtoRegin : in STD_LOGIC;
			MemtoRegout : out STD_LOGIC;
			RegWritein : in STD_LOGIC;
			RegWriteout : out STD_LOGIC
	);
end EMRegister;

architecture Behavioral of EMRegister is

signal localReg: STD_LOGIC_VECTOR(3 downto 0);
signal localALUresult: STD_LOGIC_VECTOR(15 downto 0);
signal localdata2: STD_LOGIC_VECTOR(15 downto 0);
signal localMemRead: STD_LOGIC;
signal localMemWrite: STD_LOGIC;
signal localMemtoReg: STD_LOGIC;
signal localRegWrite: STD_LOGIC;
signal state: STD_LOGIC_VECTOR(1 downto 0);

begin

Regout<=localReg;
data2out<=localdata2;
ALUresultout<=localALUresult;
MemReadout<=localMemRead;
MemWriteout<=localMemWrite;
MemtoRegout<=localMemtoReg;
RegWriteout<=localRegWrite;
process(clk)
begin
	if(rst='0') then
		localPC<="0000000000000000";
			localReg<="0000";
			localdata2<="0000000000000000";
			localALUresult<="0000000000000000";
			localMemRead<='0';
			localMemWrite<='0';
			localMemtoReg<='0';
			localRegWrite<='0';
			state<="00";
	elsif(clk'event and clk='1') then
		case (state) is
			when "00" =>
				if(EXMEMWrite='1') then
				localReg<=Regin;
				localdata2<=data2in;
				localALUresult<=ALUresultin;
				localMemRead<=MemReadin;
				localMemWrite<=MemWritein;
				localMemtoReg<=MemtoRegin;
				localRegWrite<=RegWritein;
				end if;
				state<="01";
			when "01" =>
				state<="10";
			when "10" =>
				state<="00";
		end case;
	end if;
end process;

end Behavioral;

