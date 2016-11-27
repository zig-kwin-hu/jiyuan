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
           	);	
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
           ALUdata : out  STD_LOGIC_VECTOR (15 downto 0));
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
           	data3 :	in  STD_LOGIC_VECTOR (15 downto 0);--MEM.re_ALU/re_Mem
			forward: in STD_LOGIC_VECTOR (1 downto 0);           	
			ALUdata : out  STD_LOGIC_VECTOR (15 downto 0));
	 end component;

	 component Alu is
	 Port ( 	op: in STD_LOGIC_VECTOR (3 downto 0);
    		A,B: in  STD_LOGIC_VECTOR (15 downto 0);
			--led : out  STD_LOGIC_VECTOR (15 downto 0);
			re: out  STD_LOGIC_VECTOR (15 downto 0)
			);
	 end component;

begin
	
	io_comp:IO port map(
		clk=>clk,
		rst=>rst,
		MemRead => memreadout_exmemreg,
		MemWrite => memwriteout_exmemreg,
		ram_data =>	data2out_exmemreg,
		ram_addr => aluresult,
		ins_addr => pc,
		data_out	=> data_ram2,
		ins_out=> data,
		tsre=>tsre,
		tbre=>tbre,
		rdn => rdn,
		wrn => wrn,
		
		ram1_addr => addr1,
		ram1_data =>data11,
		ram1_en => ram1EN,
		ram1_oe => ram1OE,		
		ram1_we => ram1WE,			
		ram2_oe => ram2OE,
		ram2_we => ram2WE,
		ram2_en => ram2EN,
		
		ram2_addr => addr21,
		ram2_data => data21,
		data_ready => dataready
		
	);
	
	led_comp:led port map(
		ledin=>pc(7 downto 0),
		led1=>sw2,
		led2=>sw1
	);

	clock_comp:clock port map(
		clk =>clk,
		clk2 => clk2,
		clk4 => clk4,
		clk8 => clk8,
		clk16 => clk16,
		clk15 => clk15
	);


	PCChoose_comp:PCChoose port map(
		PCSrc => pcsrc,
      PCwrite => pcwrite,
		rst => rst,
      PCin =>pcoutfrompcadd1,
      PCin2 => pcout_exmemreg,
      PCout => pcout
	);

	PCRegister_comp:PCRegister port map(
		PCSrc => pcout,
      PC => pc,
		rst=>rst,
		clk=>clk15
	);

	PCAdd1_comp:PCAdd1 port map(
		PCin => pc,
      PCout =>pcoutfrompcadd1
	);

	
	sw(7)<=pcsrc;
	sw(6 downto 0)<=data_ram2(6 downto 0);
	sw(15 downto 8)<=re_alu(7 downto 0);

	IFIDRegister_comp:IFIDRegister port map(
		IFIDWrite =>ifidwrite,
		clk =>clk15,
		rst => rst,
		PCin => pcoutfrompcadd1,
		PCout => pcoutfromifidregister,
		Commandin => data,
		Commandout => commandout,
		Imm => imm,
		rx => rx,
		ry => ry,
		--led=>sw,
		rz => rz
	);

	Test_comp:Test port map(
		PCSrc => pcsrc,
		PCWrite => pcwrite,
		reset => reset,
		rst => rst,
		alusrc => alusrc,
		alusrc2 => alusrc2,
		IFIDWrite => ifidwrite,
		IDEXWrite => idexwrite,
		EXMEMWrite => exmemwrite,
		IDEXMemRead => memreadout, 
		IDEXRy => ryout_idexreg,           
		IDEXRx => rxout_idexreg,         
		IFIDRx => rx,   
		regdst =>regdst,
		IFIDRy =>ry            
	);


	control_comp:control port map(
		Command => commandout,
		rst => rst,
		reset => reset,               --???????????????/
		RegWrite => regwrite,
		MemRead => memread,
		MemWrite => memwrite,
		MemtoReg => memtoreg,
		ALUSrc => alusrc,
		Branch => branch,
		PCSrc2 => pcsrc2,
		ALUSrc2 => alusrc2,
		RegDst => regdst,
		ALUOP => aluop,
		ImmSrc => immsrc,
		CommandOP=>commandopidex
	);
	
	--sw(15 downto 8)<=data_tranaludata1(7 downto 0);
	--sw(7 downto 0)<=data_tranaludata2(7 downto 0);
	--sw(15 downto 8)<=re_alu(7 downto 0);
	--sw(7)<=aluresult(7 downto 0);
	
	Registers_comp:Registers port map(
		clk => clk8,
		rst => rst,                --?????????????????
		rx => rx,
		ry => ry,
		wr => wr_registers,
		wd => memresult,
		SPdata => spdata, 
		Tdata => tdata,
		IHdata => ihdata,
		data1 => data1,
		data2 => data2,
		--led=>sw(15 downto 0),
		RegWrite => regwrite1
	);
	
	ImmExtend_comp:ImmExtend port map(
		instrution => commandout(10 downto 0),    --ÕâÊÇifidregisterµÄÊä³ö£¬¶ÔÂð£¿?????????????/
		ImmSrc => immsrc,
		imm16 => imm16
	);

	RegDstMUX2_comp:RegDstMUX2 port map(
		Rxin => rx,
		Ryin => ry,
		Rzin => rz,
		RegDst => regdst,
		Rxout => rxout_regdstmux2,
		Ryout => ryout_regdstmux2,
		Rzout => rzout_regdstmux2
	);


	IDEXRegister_comp:IDEXRegister port map(
		IDEXWrite => idexwrite,
		clk => clk15,
		rst => rst,
		PCin => pcoutfromifidregister,          --not sure ????????????????????
		PCout => pcoutfromidexregister,
		PCSrc2in => pcsrc2,            -- from control not sure???????/
		PCSrc2out => pcsrc2out,
		Immin => imm16,
		Immout => immout,
      rxin => rxout_regdstmux2,
		ryin => ryout_regdstmux2,
		rzin => rzout_regdstmux2,
		rxout => rxout_idexreg,
		CommandOPin=> commandopidex,
		CommandOPout=> commandopinforward,
		ryout => ryout_idexreg,
		rzout => rzout_idexreg,
		data1in => data1,
		data2in => data2,
		SPdatain => spdata,
		Tdatain => tdata,
		IHdatain => ihdata,
		ALUSrcin => alusrc,               --??????????????????/
		ALUSrc2in => alusrc2,              --?????????/
		ALUOPin => aluop,                --?????????
		RegDstin => regdst, 					--?????????
		MemReadin => memread,					 --?????????
		MemWritein => memwrite,					 --?????????
		Branchin => branch,					 --?????????
		MemtoRegin => memtoreg,				 --?????????
		RegWritein => regwrite,					 --?????????
		data1out => data1out,
		data2out => data2out,
		SPdataout => spdataout,
		Tdataout => tdataout,
		IHdataout => ihdataout,
		ALUSrcout => alusrcout,
		ALUSrc2out => alusrc2out,
		ALUOPout => aluopout,
		RegDstout => regdstout,
		MemReadout => memreadout,
		MemWriteout  => memwriteout,
		Branchout  => branchout,
		MemtoRegout  => memtoregout,
		--led =>sw(4),
		RegWriteout  => regwriteout
	);


	PCAddImm_comp:PCAddImm port map(
		PCin => pcoutfromidexregister,
		Imm => immout,
		PCout => pcout_pcaddimm
	);

	--sw(3 downto 0)<="1111";
	--sw(15 downto 12)<=PC(3 downto 0);
	--sw(11 downto 8)<=memresult(3 downto 0);
	--sw(7 downto 0)<=pc(7 downto 0);
	--sw(15 downto 8)<=memresult(7 downto 0);
	--sw1(6 downto 0)<="1111111";
	--sw(7 downto 4)<=pcout_exmemreg(3 downto 0);

	ALUSrc2MUX_comp:ALUSrc2MUX port map(
		data1 => data1out,
		data2 => data2out,
		PCdata => pcoutfromidexregister,     --not sure??????????????????
		Tdata => tdataout,
		SPdata => spdataout,
		IHdata => ihdataout,
		ALUSrc2 => alusrc2out,
		ALUdata1 => aludata1_alusrc2mux
	);


	ALUSrcMUX_comp:ALUSrcMUX port map(
		data2 => data2out,
		Imm => immout,
		ALUSrc => alusrcout,
		ALUdata2 => aludata2_alusrcmux
	
	);
 
	TranALUdata1_comp:TranALUdata1 port map(
		Forward => forwarda,
		ALUdata => aludata1_alusrc2mux,
		ALUresult => aluresult,
		Memresult => memresult,
		data => data_tranaludata1
	);
	
	TranALUdata2_comp:TranALUdata1 port map(
		Forward => forwardb,
		ALUdata => aludata2_alusrcmux,
		ALUresult => aluresult,
		Memresult => memresult,
		data => data_tranaludata2
	);
	
	TranMemdata2_comp:TranALUdata1 port map(
		Forward => forwardc,
		ALUdata => data2out,
		ALUresult => aluresult,
		Memresult => memresult,
		data => data_tranmemdata2
	);

	Forward_comp : Forward port map(
		IDEXALUSrc =>alusrcout,
		IDEXALUSrc2 =>alusrc2out,
		MEMWBRegWrite => regwrite1,
		EXMEMRegWrite => regwriteout_exmemreg,
		EXMEMrd => rdout_exmemreg,
		MEMWBrd => wr_registers,
		IDEXrx => rxout_idexreg,
		IDEXry => ryout_idexreg,
		--led => sw(15 downto 14),
		ForwardA => forwarda,
		ForwardC => forwardc,
		CommandOPin => commandopinforward,
		ForwardB => forwardb
	);

	PCSrc2MUX_comp:PCSrc2MUX port map(
		PCSrc2 => pcsrc2out,
		
		PC => pcout_pcaddimm,
		rx => data1out,                         --ÄÄÀïÀ´µÄ£¿ ²»ÖªµÀ????????????????//
		PCout => pcout_pcsrc2mux
	);

	RegDstMUX_comp:RegDstMUX port map(
		RegDst => regdstout,
		Rx =>	rxout_idexreg,
		Ry => ryout_idexreg,
		Rz => rzout_idexreg,
		Rd => rd_regdstmux
	);
	
	alu_comp:alu port map(
		op => aluopout,
		A => data_tranaludata1,
		B => data_tranaludata2,
		--led =>sw,
		re => re_alu
	);
	
	EXMEMRegister_comp:EXMEMRegister port map(
		EXMEMWrite => exmemwrite, 
		clk => clk15,
		rst => rst,
		PCin => pcout_pcsrc2mux,
		PCout => pcout_exmemreg,
		rdin => rd_regdstmux,
		rdout => rdout_exmemreg,
		ALUresultin => re_alu,
		ALUresultout => aluresult,
		data2in => data_tranmemdata2,
		MemReadin => memreadout,
		MemWritein => memwriteout,
		Branchin => branchout,
		MemtoRegin => memtoregout,
		RegWritein => regwriteout,
		data2out => data2out_exmemreg,
		MemReadout => memreadout_exmemreg,
		MemWriteout => memwriteout_exmemreg,
		Branchout => branchout_exmemreg,
		MemtoRegout => memtoregout_exmemreg,
		--led=>sw(15),
		--led1=>sw(14),
		RegWriteout  =>regwriteout_exmemreg
	);
	
	PCAnd_comp:PCAnd port map(
		ALUout => aluresult(0),
		Branch => branchout_exmemreg,
		PCSrc => pcsrc
	);
	
--	sw(15)<=memwriteout_exmemreg;
--	sw(14)<=memreadout_exmemreg;
--	sw(13 downto 8)<=data2out_exmemreg(5 downto 0);
	--sw(7 downto 0)<=data_ram2(7 downto 0);

	MEMWBRegister_comp:MEMWBRegister port map(
		clk => clk15,
		rst => rst,
		rdin => rdout_exmemreg,
		rdout => wr_registers,                  --Ó¦¸ÃÊÇÃ»´írd¾ÍÊÇ¼Ä´æÆ÷¶ÑÏëÒªµÄwr????
		ALUresultin => aluresult,
		ALUresultout => aluresultout,
		Memin => data_ram2,
		Memout => memout,
		MemtoRegin => memtoregout_exmemreg,
		RegWritein =>regwriteout_exmemreg,
		MemtoRegout => memtoregout_memwbreg,
		RegWriteout  => regwrite1
	);
	
	MemtoRegMUX_comp:MemtoRegMUX port map(
		 MemtoReg => memtoregout_memwbreg,
		 Memdata => memout,
		 ALUdata => aluresultout,
		 outdata  => memresult
	);

end Behavioral;

