library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DERegister is
	  port( IDEXWrite: in  STD_LOGIC;
			clk: in STD_LOGIC;
			rst: in STD_LOGIC;
			Immin : in STD_LOGIC_VECTOR (15 downto 0);
           	Immout : out  STD_LOGIC_VECTOR (15 downto 0);
           	R1in : in  STD_LOGIC_VECTOR (3 downto 0);
           	R2in : in  STD_LOGIC_VECTOR (3 downto 0);
			RegDstin : in  STD_LOGIC_VECTOR (3 downto 0);
			R1out : out STD_LOGIC_VECTOR (3 downto 0);
			R2out : out STD_LOGIC_VECTOR (3 downto 0);
			RegDstout : out STD_LOGIC_VECTOR (3 downto 0);
			data1in : in STD_LOGIC_VECTOR (15 downto 0);
			data2in : in STD_LOGIC_VECTOR (15 downto 0);
			data1out : out STD_LOGIC_VECTOR (15 downto 0);
			data2out : out STD_LOGIC_VECTOR (15 downto 0);
			--E
			AluOPin : in STD_LOGIC_VECTOR(3 downto 0);
			AluOPout : out STD_LOGIC_VECTOR(3 downto 0);
			AluSrcin : in STD_LOGIC;
			AluSrcout : out STD_LOGIC;
			--M
			MemWritein : in STD_LOGIC;
			MemWriteout : out STD_LOGIC;
			MemReadin : in STD_LOGIC;
			MemReadout : out STD_LOGIC;
			--W
			MemtoRegin : in STD_LOGIC_VECTOR(1 downto 0);
			MemtoRegout : out STD_LOGIC_VECTOR(1 downto 0);
			RegWritein : in STD_LOGIC;
			RegWriteout : out STD_LOGIC
			  );
end DERegister;

architecture Behavioral of DERegister is

signal localImm: STD_LOGIC_VECTOR(15 downto 0);
signal localR1: STD_LOGIC_VECTOR(3 downto 0);
signal localR2: STD_LOGIC_VECTOR (3 downto 0);
signal localRegDst: STD_LOGIC_VECTOR (3 downto 0);
signal localdata1: STD_LOGIC_VECTOR (15 downto 0);
signal localdata2: STD_LOGIC_VECTOR (15 downto 0);
signal localAluSrc: STD_LOGIC;
signal localAluOP: STD_LOGIC_VECTOR (3 downto 0);
signal localMemRead: STD_LOGIC;
signal localMemWrite: STD_LOGIC := '0';
signal localMemtoReg: STD_LOGIC_VECTOR(1 downto 0);
signal localRegWrite: STD_LOGIC := '0';
signal state:STD_LOGIC_VECTOR(1 downto 0) := "00";

begin
Immout<=localImm;
R1out<=localR1;
R2out<=localR2;
RegDstout<=localRegDst;
data1out<=localdata1;
data2out<=localdata2;
AluSrcout<=localAluSrc;
AluOPout<=localAluOP;
MemReadout<=localMemRead;
MemWriteout<=localMemWrite;
MemtoRegout<=localMemtoReg;
RegWriteout<=localRegWrite;
process(clk,rst)
begin
		if(rst='0') then
			localImm<="0000000000000000";
			localR1<="0000";
			localR2<="0000";
			localRegDst<="0000";
			localdata1<="0000000000000000";
			localdata2<="0000000000000000";
			localAluSrc<='0';
			localAluOP<="0000";
			localMemRead<='0';
			localMemWrite<='0';
			localMemtoReg<="00";
			localRegWrite<='0';
			state<="00";
		elsif(clk'event and clk='1') then
			case state is
				when "00" =>
					if(IDEXWrite='1') then
					localImm<=Immin;
					localR1<=R1in;
					localR2<=R2in;
					localRegDst<=RegDstin;
					localdata1<=data1in;
					localdata2<=data2in;
					localAluSrc<=AluSrcin;
					localAluOP<=AluOPin;
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
				when others =>
					state <="00";
			end case;
		end if;
end process;
end Behavioral;

