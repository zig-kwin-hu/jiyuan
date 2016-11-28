library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MWRegister is
	port(	MEMWBWrite:in STD_LOGIC;
			  clk : in STD_LOGIC;
			  rst : in STD_LOGIC;
			  Regin: in STD_LOGIC_VECTOR(3 downto 0);
			  Regout: out STD_LOGIC_VECTOR(3 downto 0);
			  Aluresultin: in STD_LOGIC_VECTOR(15 downto 0);
			  Aluresultout: out STD_LOGIC_VECTOR(15 downto 0);
			  Memin: in STD_LOGIC_VECTOR(15 downto 0);
			  Memout: out STD_LOGIC_VECTOR(15 downto 0);
			  data2in : in STD_LOGIC_VECTOR (15 downto 0);
			  data2out : out STD_LOGIC_VECTOR (15 downto 0);
			  --W
			  MemtoRegin : in STD_LOGIC_VECTOR(1 downto 0);
			  RegWritein : in STD_LOGIC;
			  MemtoRegout : out STD_LOGIC_VECTOR(1 downto 0); 
			  RegWriteout : out STD_LOGIC
	);
end MWRegister;

architecture Behavioral of MWRegister is

signal localReg: STD_LOGIC_VECTOR(3 downto 0);
signal localAluresult: STD_LOGIC_VECTOR(15 downto 0);
signal localMem: STD_LOGIC_VECTOR(15 downto 0);
signal localMemtoReg: STD_LOGIC_VECTOR(1 downto 0);
signal localRegWrite: STD_LOGIC := '0';
signal localdata2: STD_LOGIC_VECTOR(15 downto 0);
signal state: STD_LOGIC_VECTOR(1 downto 0) := "00";

begin

Regout<=localReg;
Aluresultout<=localAluresult;
Memout<=localMem;
MemtoRegout<=localMemtoReg;
RegWriteout<=localRegWrite;
data2out<=localdata2;

process(clk) is
begin
	if(rst='0') then
		localReg<="0000";
		localAluresult<="0000000000000000";
		localMem<="0000000000000000";
		localMemtoReg<="00";
		localRegWrite<='0';
		localdata2<="0000000000000000";
		state<="00";
	elsif(clk'event and clk='1') then
		case state is
			when "00" =>
				if(MEMWBWrite='1') then
					localReg<=Regin;
					localAluresult<=Aluresultin;
					localMem<=Memin;
					localMemtoReg<=MemtoRegin;
					localRegWrite<=RegWritein;
					localdata2<=data2in;
				end if;
				state<="01";
			when "01" =>
				state<="10";
			when "10" =>
				state<="00";
			when others =>
				state <= "00";
		end case;
	end if;
end process;

end Behavioral;