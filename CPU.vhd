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
			
         ram1addr : out  STD_LOGIC_VECTOR (17 downto 0); --将地址输给cpld的接口
         data1 : inout  STD_LOGIC_VECTOR (15 downto 0); --cpld返回的数据（指令）  
         ram1OE : out  STD_LOGIC;
			ram1WE : out  STD_LOGIC;
			ram1EN : out  STD_LOGIC;
			
         ram2addr : out  STD_LOGIC_VECTOR (17 downto 0); --将地址输给cpld的接口
         data2 : inout  STD_LOGIC_VECTOR (15 downto 0); --cpld返回的数据（指令）
         ram2OE : out  STD_LOGIC;
			ram2WE : out  STD_LOGIC;
         ram2EN : out  STD_LOGIC
			
			  );
end CPU;
architecture Behavioral of CPU is

--FDRegister component
component FDRegister is
	 port ( 	
	 		IsBubble : in  STD_LOGIC;
			clk: in STD_LOGIC;
			rst: in STD_LOGIC;
           	PCin : in  STD_LOGIC_VECTOR (15 downto 0);
			PCout : out STD_LOGIC_VECTOR (15 downto 0);
           	Commandin : in  STD_LOGIC_VECTOR (15 downto 0);
           	Commandout : inout  STD_LOGIC_VECTOR (15 downto 0)
           );	
end component;

--DERegister component
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
			MemtoRegin : in STD_LOGIC_VECTOR(1 downto 0);
			MemtoRegout : out STD_LOGIC_VECTOR(1 downto 0);
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
	 end component;

component MWRegister is
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
end component;

component AluSrcMUX is
	 Port ( data1 : in  STD_LOGIC_VECTOR (15 downto 0);--data2 from register
           data2 : in  STD_LOGIC_VECTOR (15 downto 0);--immediate
           AluSrc : in  STD_LOGIC;
           ALUdata : out  STD_LOGIC_VECTOR (15 downto 0)
           );
end component;

component Forward is
	 Port ( 	MEMWBRegWrite : in  STD_LOGIC;
           	EXMEMRegWrite : in  STD_LOGIC;
           	EXMEMrd : in  STD_LOGIC_VECTOR (3 downto 0);--EM.RegDst
           	MEMWBrd : in  STD_LOGIC_VECTOR (3 downto 0);--MW.RegDst
           	IDEXrx : in  STD_LOGIC_VECTOR (3 downto 0);--DE.R1
           	IDEXry : in  STD_LOGIC_VECTOR (3 downto 0);--DE.R2
           	ForwardA : out  STD_LOGIC_VECTOR (1 downto 0);
           	ForwardB : out  STD_LOGIC_VECTOR (1 downto 0)
           );
end component;

component ForwardMUX is
	Port ( 	data1 : in  STD_LOGIC_VECTOR (15 downto 0);--Reg
           	data2 : in  STD_LOGIC_VECTOR (15 downto 0);--EX.re_Alu
           	data3 :	in  STD_LOGIC_VECTOR (15 downto 0);--MEM.re_ALU/re_Mem
			forward: in STD_LOGIC_VECTOR (1 downto 0);           	
			ALUdata : out  STD_LOGIC_VECTOR (15 downto 0)
		);
end component;

component Alu is
	Port ( 	op: in STD_LOGIC_VECTOR (3 downto 0);
    		A: in  STD_LOGIC_VECTOR (15 downto 0);
    		B: in  STD_LOGIC_VECTOR (15 downto 0);
			re: out  STD_LOGIC_VECTOR (15 downto 0)
			);
end component;

--PCChoose component
component PCChoose is
port(
		PCsrc : in STD_LOGIC_VECTOR(1 downto 0);
		PCadd1 : in STD_LOGIC_VECTOR(15 downto 0);
		PCjump : in STD_LOGIC_VECTOR(15 downto 0);
		PCout : out STD_LOGIC_VECTOR(15 downto 0)
	);
end component;

--PCRegister component
component PCRegister is
port(
		rst : in STD_LOGIC;
		clk : in STD_LOGIC;
		PCin : in STD_LOGIC_VECTOR(15 downto 0);
		PCout : out STD_LOGIC_VECTOR(15 downto 0);
		bubble : in STD_LOGIC
	);
end component;

--PCMem component
component PCSim is
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
end component;

--PCAdd1 component
component PCAdd1 is
port(
		PCin : in STD_LOGIC_VECTOR(15 downto 0);
		PCout : out STD_LOGIC_VECTOR(15 downto 0)
	);
end component;

--IO component
component IO is
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
		dataout : out STD_LOGIC_VECTOR(15 downto 0)
	);
end component;

--ToRegMux component
component ToRegMux is
port(
		MemToReg : in STD_LOGIC_Vector(2 downto 0);
		MemResult : in STD_LOGIC_Vector(15 downto 0);
		ALUResult : in STD_LOGIC_Vector(15 downto 0);
		RegResult : in STD_LOGIC_Vector(15 downto 0);
		Result : out STD_LOGIC_Vector(15 downto 0)
	);
end component;

--ID_topmodual component
component ID_topmodual is
port(
		IFIDWrite 		: in STD_LOGIC; -- unused now
    	clk 				: in STD_LOGIC;
    	rst 				: in STD_LOGIC;
    	PCin 			: in STD_LOGIC_VECTOR(15 downto 0);
		PCRegister		: in STD_LOGIC_VECTOR(15 downto 0);
		 
		Reg1_out 		: out STD_LOGIC_VECTOR(15 downto 0);
		Reg2_out 		: out STD_LOGIC_VECTOR(15 downto 0);
		ALUOP 			: out STD_LOGIC_VECTOR(3 downto 0);
		ALUSRC 			: out STD_LOGIC;
		RegDst 			: out STD_LOGIC_VECTOR(3 downto 0);
		immediate_out	: out STD_LOGIC_VECTOR(15 downto 0);
		immediate_in2	: out STD_LOGIC_VECTOR(10 downto 0); -- signal for debug
		MemRead			: out STD_LOGIC;
		MemWrite		: out STD_LOGIC;
		MemToReg		: out STD_LOGIC_VECTOR(1 downto 0);
		RegWrite		: out STD_LOGIC;
		PCout			: out STD_LOGIC_VECTOR(15 downto 0);
	 
    	reg_write_loc 	: in  STD_LOGIC_VECTOR (3 downto 0);
    	reg_write_data 	: in  STD_LOGIC_VECTOR (15 downto 0);
    	reg_write_signal : in  STD_LOGIC;
	 
		isBubble : in STD_LOGIC;
	 
		jmp	: out STD_LOGIC
	);
end component;

--FDReg
signal pcin_fd : STD_LOGIC_VECTOR(15 downto 0);
signal pcout_fd : STD_LOGIC_VECTOR(15 downto 0);
signal commandout_fd : STD_LOGIC_VECTOR(15 downto 0);
signal commandin_fd : STD_LOGIC_VECTOR(15 downto 0);

--IDEXReg
signal idexwrite : STD_LOGIC := '1';
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
	signal aluopout_idex:STD_LOGIC_VECTOR(3 downto 0);
	signal alusrcout_idex:STD_LOGIC;
	signal aluopin_idex:STD_LOGIC_VECTOR(3 downto 0);
	signal alusrcin_idex:STD_LOGIC;
	--IDEX.M
	signal memwriteout_idex:STD_LOGIC;
	signal memreadout_idex:STD_LOGIC;
	signal memwritein_idex:STD_LOGIC;
	signal memreadin_idex:STD_LOGIC;
	--IDEX.W
	signal memtoregout_idex:STD_LOGIC_VECTOR(1 downto 0);
	signal regwriteout_idex:STD_LOGIC;
	signal memtoregin_idex:STD_LOGIC_VECTOR(1 downto 0);
	signal regwritein_idex:STD_LOGIC

--E
signal alusrc1_e:STD_LOGIC_VECTOR(15 downto 0);
signal alusrc2_e:STD_LOGIC_VECTOR(15 downto 0);
signal forwardA_e:STD_LOGIC_VECTOR(1 downto 0);
signal forwardB_e:STD_LOGIC_VECTOR(1 downto 0)

--EXMEMReg
signal exmemwrite_exmem : STD_LOGIC := '1';
signal regout_exmem:STD_LOGIC_VECTOR(3 downto 0);
signal ALUresultout_exmem:STD_LOGIC_VECTOR(15 downto 0);
signal data2out_exmem:STD_LOGIC_VECTOR (15 downto 0);
--signal regin_exmem:STD_LOGIC_VECTOR(3 downto 0);
signal ALUresultin_exmem:STD_LOGIC_VECTOR(15 downto 0);
signal data2in_exmem:STD_LOGIC_VECTOR (15 downto 0);
	--EXMEM.M
	signal memwriteout_exmem:STD_LOGIC;
	signal memreadout_exmem:STD_LOGIC;
	--EXMEM.W
	signal memtoregout_exmem:STD_LOGIC;
	signal regwriteout_exmem:STD_LOGIC := '0';

--MWReg
signal memwbwrite_memwri : STD_LOGIC := '1';
signal regin_memwri : STD_LOGIC_VECTOR(3 downto 0);
signal regout_memwri : STD_LOGIC_VECTOR(3 downto 0);
signal aluresultin_memwri : STD_LOGIC_VECTOR(15 downto 0);
signal aluresultout_memwri : STD_LOGIC_VECTOR(15 downto 0);
signal memin_memwri : STD_LOGIC_VECTOR(15 downto 0);
signal memout_memwri : STD_LOGIC_VECTOR(15 downto 0);
signal data2in_memwri : STD_LOGIC_VECTOR(15 downto 0);
signal data2out_memwri : STD_LOGIC_VECTOR(15 downto 0);
	--W
	signal memtoregin_memwri : STD_LOGIC;
	signal memtoregout_memwri : STD_LOGIC;
	signal regwritein_memwri : STD_LOGIC;
	signal regwriteout_memwri : STD_LOGIC := '0';



--Forward signal
signal forwarda_forward : STD_LOGIC_VECTOR(1 downto 0);
signal forwardb_forward : STD_LOGIC_VECTOR(1 downto 0);

--PCChoose signal
signal	pcsrc : STD_LOGIC_VECTOR(1 downto 0) := "00";

--signal	pcadd1 : STD_LOGIC_VECTOR(15 downto 0);
signal	pcjump : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal	pcchooseout : STD_LOGIC_VECTOR(15 downto 0); 

--PCRegister signal
signal pcregisterout : STD_LOGIC_VECTOR(15 downto 0);
signal isbubble_pc_fd : STD_LOGIC := '0';
signal isbubble_pcregister : STD_LOGIC := '0';

--PCMem signal
--signal pcmemout : STD_LOGIC_VECTOR(15 downto 0);

--ForwardMUX1 signal
signal aludata_forwardmux1 : STD_LOGIC_VECTOR(15 downto 0);

--ForwardMUX1 signal
signal aludata_forwardmux2 : STD_LOGIC_VECTOR(15 downto 0);

--AluSrcMUX signal
signal aludata_alusrc : STD_LOGIC_VECTOR(15 downto 0);

--IO signal

--ToRegMux signal
signal result_toregmux : STD_LOGIC_VECTOR(15 downto 0);

--ID_topmodual signal
signal ifidwrite_id_topmodual : STD_LOGIC := '1';

--maoxian signal
signal isbubble_pc_fd_de : STD_LOGIC := '0';

begin
isbubble_pcregister <= isbubble_pc_fd or isbubble_pc_fd_de;
process
begin
if((memwriteout_exmem or memreadout_exmem) and ((ALUresultout_exmem <= x"7FFF") and (ALUresultout_exmem >= x"4000"))) then
	pcbubble <= '1';
else
	pcbubble <= '0';
end if;
end process;
--PCChoose port map
PCChoose_comp:PCChoose port map(
		PCSrc => pcsrc,
      	PCadd1 => pcin_fd,
      	PCjump => pcjump,
      	PCout => pcchooseout
	);

--PCRegister port map
PCRegister_comp:PCRegister port map(
		rst => rst,
		clk => clk,
		PCin => pcchooseout,
		PCout => pcregisterout,
		bubble => isbubble_pcregister
	);

--PCMem port map
PCSim_comp:PCSim port map(
		rst => rst,
		clk => clk,
		PCaddress => pcregisterout,
		ram2address => ram2addr,
		ram2data => data2,
		ram2_en => ram2EN,
		ram2_we => ram2WE,
		ram2_oe => ram2OE,
		PCout => commandin_fd,
		bubble => isbubble_pc_fd

	);

--PCAdd1 port map
PCAdd1_comp:PCAdd1 port map(
		PCin => pcregisterout,
		PCout => pcin_fd
	);

--FDRegister port map
FDRegister_comp:FDRegister port map(
		IsBubble => isbubble_pc_fd_de,
		clk => clk,
		rst => rst,
        PCin => pcin_fd,
		PCout => pcout_fd,
        Commandin => commandin_fd,
        Commandout => commandout_fd
	);

--DERegister port map
DERegister_comp:DERegister port map(
			IDEXWrite => idexwrite,
			clk => clk,
			rst => rst,
			Immin => immin_idex,
           	Immout => immout_idex,
           	R1in => r1in_idex,
           	R2in => r2in_idex,
			RegDstin => regdstin_idex;
			R1out => r1out_idex;
			R2out = r2out_idex;
			RegDstout => regdstout_idex,
			data1in => data1in_idex,
			data2in => data2in_idex,
			data1out => data1out_idex,
			data2out => data2out_idex,
			--E
			ALUOPin => aluopin_idex,
			ALUOPout => aluopout_idex,
			ALUSrcin => alusrcin_idex,
			ALUSrcout => alusrcout_idex,
			--M
			MemWritein => memwritein_idex,
			MemWriteout => memwriteout_idex,
			MemReadin => memreadin_idex,
			MemReadout => memreadout_idex,
			--W
			MemtoRegin => memtoregin_idex,
			MemtoRegout => memtoregout_idex,
			RegWritein => regwritein_idex,
			RegWriteout => regwriteout_idex
	);

--ForwardMUX1 port map
ForwardMUX_comp1:ForwardMUX port map(
			data1 => data1out_idex,--Reg
           	data2 => ALUresultout_exmem,--EX.re_Alu
           	data3 => aluresultout_memwri,--MEM.re_ALU/re_Mem
			forward => forwarda_forward,          	
			ALUdata => aludata_forwardmux1
	);

--ForwardMUX port map
ForwardMUX_comp2:ForwardMUX port map(
			data1 => data2out_idex,--Reg
           	data2 => ALUresultout_exmem,--EX.re_Alu
           	data3 => aluresultout_memwri,--MEM.re_ALU/re_Mem
			forward => forwardb_forward           	
			ALUdata => aludata_forwardmux2
	);

--Forward port map
Forward_comp:Forward port map(
			MEMWBRegWrite => regwriteout_memwri,
           	EXMEMRegWrite => regwriteout_exmem,
           	EXMEMrd => regout_exmem,--EM.RegDst
           	MEMWBrd => regout_memwri,--MW.RegDst
           	IDEXrx => r1out_idex,--DE.R1
           	IDEXry => r2out_idex,--DE.R2
           	ForwardA => forwarda_forward,
           	ForwardB => forwardb_forward
	);

--ALUSrcMUX port map
AluSrcMUX_comp:AluSrcMUX port map(
		   data1 => aludata_forwardmux2,--data2 from register
           data2 =>	immout_idex,--immediate
           AluSrc => alusrcout_idex,
           ALUdata => aludata_alusrc
	);

--ALU port map
Alu_comp:Alu port map(
		op => aluopout_idex,
    	A => aludata_forwardmux1,
    	B => aludata_alusrc,
		re => ALUresultin_exmem
	);

--EMRegister port map
EMRegister_comp:EMRegister port map(
		EXMEMWrite => exmemwrite_exmem,--stall signal?
			clk => clk,
			rst => rst,
			Regin => regdstout_idex,
			Regout => regout_exmem,
			ALUresultin => ALUresultin_exmem,
			ALUresultout => ALUresultout_exmem,
			data2in => aludata_forwardmux2,
			data2out => data2out_exmem,
			--M
			MemWritein => memwriteout_idex,
			MemWriteout => memwriteout_exmem,
			MemReadin => memreadout_idex,
			MemReadout => memreadout_exmem,
			--W
			MemtoRegin => memtoregout_idex,
			MemtoRegout => memtoregout_exmem,
			RegWritein => regwriteout_idex,
			RegWriteout => regwriteout_exmem
	);

--IO port map
IO_comp:IO port map(
		rst => rst,
		clk => clk,
		address => ALUresultout_exmem,
		data => data2out_exmem,
		MemWrite => memwriteout_exmem,
		MemRead => memreadout_exmem,
		ram1_oe => ram1OE,
		ram1_we => ram1WE,
		ram1_en => ram1EN,
		addressram1 => ram1addr,
		dataram1 => data1,
		ram2_oe => ram2OE,
		ram2_we => ram2WE,
		ram2_en => ram2EN,
		addressram2 => ram2addr,
		dataram2 => data2,
		dataout => memin_memwri
	);

--MWRegister
MWRegister_comp:MWRegister port map(
			  MEMWBWrite => memwbwrite_memwri,
			  clk => clk,
			  rst => rst,
			  Regin => regout_exmem,
			  Regout => regout_memwri,
			  ALUresultin => ALUresultout_exmem,
			  ALUresultout => aluresultout_memwri,
			  Memin => memin_memwri,
			  Memout => memout_memwri,
			  data2in => data2out_exmem,
			  data2out => data2out_memwri,
			  --W
			  MemtoRegin => memtoregout_exmem,
			  RegWritein => regwriteout_exmem,
			  MemtoRegout => memtoregout_memwri,
			  RegWriteout => regwriteout_memwri
	);

--ToRegMux
ToRegMux_comp:ToRegMux port map(
		MemToReg => memtoregout_memwri,
		MemResult => memout_memwri,
		ALUResult => aluresultout_memwri,
		RegResult => data2out_memwri,
		Result => result_toregmux
	);

--ID_topmodual 
ID_topmodual_comp:ID_topmodual port map(
		IFIDWrite =>  ifidwrite_id_topmodual -- unused now
    	clk => clk,
    	rst => rst,
    	PCin => commandout_fd,
		PCRegister	=> pcout_fd,
		
		Reg1_out => r1in_idex,
		Reg2_out => r2in_idex,
		ALUOP => aluopin_idex,
		ALUSRC => alusrcin_idex,
		RegDst => regdstin_idex,
		immediate_out => immin_idex,
		immediate_in2 =>  -- signal for debug
		MemRead	=> memreadin_idex,
		MemWrite => memwritein_idex,
		MemToReg => memtoregin_idex,
		RegWrite => regwritein_idex,
		PCout => pcjump,
	
    	reg_write_loc => regout_memwri,
    	reg_write_data => result_toregmux,
    	reg_write_signal => regwriteout_memwri,
	 
		isBubble => isbubble_pc_fd_de,
	 
		jmp	=> pcsrc
	);
end Behavioral;