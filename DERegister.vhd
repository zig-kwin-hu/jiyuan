libraR2 IEEE;
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
			ALUOPin : in STD_LOGIC_VECTOR(3 downto 0);
			ALUOPout : out STD_LOGIC_VECTOR(3 downto 0);
			ALUSrcin : in STD_LOGIC;
			ALUSrcout : out STD_LOGIC;
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
end DERegister;

architecture Behavioral of DERegister is

signal localImm: STD_LOGIC_VECTOR(15 downto 0);
signal localR1: STD_LOGIC_VECTOR(3 downto 0);
signal localR2: STD_LOGIC_VECTOR (3 downto 0);
signal localRegDst: STD_LOGIC_VECTOR (3 downto 0);
signal localdata1: STD_LOGIC_VECTOR (15 downto 0);
signal localdata2: STD_LOGIC_VECTOR (15 downto 0);
signal localALUSrc: STD_LOGIC;
signal localALUOP: STD_LOGIC_VECTOR (3 downto 0);
signal localMemRead: STD_LOGIC;
signal localMemWrite: STD_LOGIC;
signal localMemtoReg: STD_LOGIC;
signal localRegWrite: STD_LOGIC;

begin
Immout<=localImm;
R1out<=localR1;
R2out<=localR2;
RegDstout<=localRegDst;
data1out<=localdata1;
data2out<=localdata2;
ALUSrcout<=localALUSrc
ALUOPout<=localALUOP;
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
			localALUSrc<='0';
			localALUOP<="0000";
			localMemRead<='0';
			localMemWrite<='0';
			localMemtoReg<='0';
			localRegWrite<='0';
		elsif(clk'event and clk='1') then
			if(IDEXWrite='0') then
				localImm<=Immin;
				localPC<=PCin;
				localR1<=R1in;
				localR2<=R2in;
				localRegDst<=RegDstin;
				localdata1<=data1in;
				localdata2<=data2in;
				localSPdata<=SPdatain;
				localTdata<=Tdatain;
				localIHdata<=IHdatain;
				localALUSrc<=ALUSrcin;
				localALUSrc2<=ALUSrc2in;
				localALUOP<=ALUOPin;
				localRegDst<=RegDstin;
				localMemRead<=MemReadin;
				localMemWrite<=MemWritein;
				localBranch<=Branchin;
				localMemtoReg<=MemtoRegin;
				localRegWrite<=RegWritein;
				localPCSrc2<=PCSrc2in;
				localCommandOP<=CommandOPin;
			end if;
	end if;
end process;
end Behavioral;

