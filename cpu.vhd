library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity CPU is
    Port ( 
			sw : out std_logic_vector ( 15 downto 0);
			sw1 : out std_logic_vector ( 6 downto 0);
			sw2 : out std_logic_vector ( 6 downto 0);
			
			clk : in  STD_LOGIC;
         rst : in  STD_LOGIC;
			
         rdn : inout  STD_LOGIC;
         wrn : inout  STD_LOGIC;		
			dataready : in std_logic;
			tbre: in std_logic;
			tsre: in std_logic;
			
         addr1 : out  STD_LOGIC_VECTOR (15 downto 0); 
         data11 : inout  STD_LOGIC_VECTOR (15 downto 0);  
         ram1OE : out  STD_LOGIC;
			ram1WE : out  STD_LOGIC;
			ram1EN : out  STD_LOGIC;
			
         addr21 : out  STD_LOGIC_VECTOR (15 downto 0);
         data21 : inout  STD_LOGIC_VECTOR (15 downto 0);
         ram2OE : out  STD_LOGIC;
			ram2WE : out  STD_LOGIC;
         ram2EN : out  STD_LOGIC
			
			  );
end CPU;

architecture Behavioral of CPU is

	component FDRegister is
	 port ( 	IsBubble : in  STD_LOGIC;
			clk: in STD_LOGIC;
			rst: in STD_LOGIC;
           	PCin : in  STD_LOGIC_VECTOR (15 downto 0);
			PCout : out STD_LOGIC_VECTOR (15 downto 0);
           	Commandin : in  STD_LOGIC_VECTOR (15 downto 0);
           	Commandout : inout  STD_LOGIC_VECTOR (15 downto 0);	
	 end component;

	 component DERegister is
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
			MemtoRegin : in STD_LOGIC;
			MemtoRegout : out STD_LOGIC;
			RegWritein : in STD_LOGIC;
			RegWriteout : out STD_LOGIC
			  );
	 end component;

	 component EMRegster is
	 port(	EXMEMWrite : in  STD_LOGIC;--stall signal?
			clk : in STD_LOGIC;
			rst : in STD_LOGIC;
			Regin: in STD_LOGIC_VECTOR(3 downto 0);
			Regout: out STD_LOGIC_VECTOR(3 downto 0);
			Aluresultin: in STD_LOGIC_VECTOR(15 downto 0);
			Aluresultout: out STD_LOGIC_VECTOR(15 downto 0);
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
	 end component;

	 component MWRegister is
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
			  MemtoRegin : in STD_LOGIC;
			  RegWritein : in STD_LOGIC;
			  MemtoRegout : out STD_LOGIC; 
			  RegWriteout : out STD_LOGIC
			  );
	 end component;

	 component AluSrcMUX is
	 Port ( data1 : in  STD_LOGIC_VECTOR (15 downto 0);--data2 from register
           data2 : in  STD_LOGIC_VECTOR (15 downto 0);--immediate
           AluSrc : in  STD_LOGIC;
           Aludata : out  STD_LOGIC_VECTOR (15 downto 0));
	 end component;

	 component Forward is
	 Port ( 	MEMWBRegWrite : in  STD_LOGIC;
           	EXMEMRegWrite : in  STD_LOGIC;
           	EXMEMrd : in  STD_LOGIC_VECTOR (3 downto 0);--EM.RegDst
           	MEMWBrd : in  STD_LOGIC_VECTOR (3 downto 0);--MW.RegDst
           	IDEXrx : in  STD_LOGIC_VECTOR (3 downto 0);--DE.R1
           	IDEXry : in  STD_LOGIC_VECTOR (3 downto 0);--DE.R2
           	ForwardA : out  STD_LOGIC_VECTOR (1 downto 0);
           	ForwardB : out  STD_LOGIC_VECTOR (1 downto 0));
	 end component;

	 component ForwardMUX is
	 Port ( 	data1 : in  STD_LOGIC_VECTOR (15 downto 0);--Reg
           	data2 : in  STD_LOGIC_VECTOR (15 downto 0);--EX.re_Alu
           	data3 :	in  STD_LOGIC_VECTOR (15 downto 0);--MEM.re_Alu/re_Mem
			forward: in STD_LOGIC_VECTOR (1 downto 0);           	
			Aludata : out  STD_LOGIC_VECTOR (15 downto 0));
	 end component;

	 component Alu is
	 Port ( 	op: in STD_LOGIC_VECTOR (3 downto 0);
    		A,B: in  STD_LOGIC_VECTOR (15 downto 0);
			re: out  STD_LOGIC_VECTOR (15 downto 0)
			);
	 end component;

	 --IDEXReg
	 signal r1out_idex:STD_LOGIC_VECTOR(3 downto 0);
	 signal r2out_idex:STD_LOGIC_VECTOR(3 downto 0);
	 signal immout_idex:STD_LOGIC_VECTOR(15 downto 0);
	 signal regdstout_idex:STD_LOGIC_VECTOR(3 downto 0);
	 signal data1out_idex:STD_LOGIC_VECTOR(15 downto 0);
	 signal data2out_idex:STD_LOGIC_VECTOR(15 downto 0);
	 signal r1in_idex:STD_LOGIC_VECTOR(3 downto 0);
	 signal r2in_idex:STD_LOGIC_VECTOR(3 downto 0);
	 signal immin_idex:STD_LOGIC_VECTOR(15 downto 0);
	 signal regdstin_idex:STD_LOGIC_VECTOR(3 downto 0);
	 signal data1in_idex:STD_LOGIC_VECTOR(15 downto 0);
	 signal data2in_idex:STD_LOGIC_VECTOR(15 downto 0);
	 	--IDEX.E
	 signal Aluopout_idex:STD_LOGIC_VECTOR(3 downto 0);
	 signal Alusrcout_idex:STD_LOGIC;
	 signal Aluopin_idex:STD_LOGIC_VECTOR(3 downto 0);
	 signal Alusrcin_idex:STD_LOGIC;
	 	--IDEX.M
	 signal memwriteout_idex:STD_LOGIC;
	 signal memreadout_idex:STD_LOGIC;
	 signal memwritein_idex:STD_LOGIC;
	 signal memreadin_idex:STD_LOGIC;
	 	--IDEX.W
	 signal memtoregout_idex:STD_LOGIC;
	 signal regwriteout_idex:STD_LOGIC;
	 signal memtoregin_idex:STD_LOGIC;
	 signal regwritein_idex:STD_LOGIC;

	 --E
	 signal Alusrc1_e:STD_LOGIC_VECTOR(15 downto 0);
	 signal Alusrc2_e:STD_LOGIC_VECTOR(15 downto 0);
	 signal forwardA_e:STD_LOGIC_VECTOR(1 downto 0);
	 signal forwardB_e:STD_LOGIC_VECTOR(1 downto 0);


	 --EXMEMReg
	 signal regout_exmem:STD_LOGIC_VECTOR(3 downto 0);
	 signal Aluresultout_exmem:STD_LOGIC_VECTOR(15 downto 0);
	 signal data2out_exmem:STD_LOGIC_VECTOR (15 downto 0);
	 signal regin_exmem:STD_LOGIC_VECTOR(3 downto 0);
	 signal Aluresultin_exmem:STD_LOGIC_VECTOR(15 downto 0);
	 signal data2in_exmem:STD_LOGIC_VECTOR (15 downto 0);
	 	--EXMEM.M
	 signal memwriteout_exmem:STD_LOGIC;
	 signal memreadout_exmem:STD_LOGIC;
	 signal memwritein_exmem:STD_LOGIC;
	 signal memreadin_exmem:STD_LOGIC;
	 	--EXMEM.W
	 signal memtoregout_exmem:STD_LOGIC;
	 signal regwriteout_exmem:STD_LOGIC;
	 signal memtoregin_exmem:STD_LOGIC;
	 signal regwritein_exmem:STD_LOGIC;

begin


end Behavioral;

