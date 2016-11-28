library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity PC_topmodual is
	port(	
		rst : in STD_LOGIC;
		clk : in STD_LOGIC;
		pcsrc : in STD_LOGIC;
		pcjump : in STD_LOGIC_VECTOR(15 downto 0);
	
		--from EMRegister
		ALUresultout_exmem : in STD_LOGIC_VECTOR(15 downto 0);
		data2out_exmem : in STD_LOGIC_VECTOR(15 downto 0);
		memwriteout_exmem : in STD_LOGIC;
		memreadout_exmem : in STD_LOGIC;
		
		datafrompcmem_pcmem : out STD_LOGIC_VECTOR(15 downto 0 );
		
		ram2addr : out STD_LOGIC_VECTOR(17 downto 0);
		data2 : inout STD_LOGIC_VECTOR(15 downto 0);
		ram2EN : out STD_LOGIC;
		ram2WE : out STD_LOGIC;
		ram2OE : out STD_LOGIC;
		commandin_fd : out STD_LOGIC_VECTOR(15 downto 0);
		isbubble_pc_fd : in STD_LOGIC;
		isbubble_pc_fd_de : in STD_LOGIC;
		pcin_fd out STD_LOGIC_VECTOR(15 downto 0)
		);
end PC_topmodual;

architecture Behavior of PC_topmodual is

--PCChoose component
component PCChoose is
port(
		PCsrc : in STD_LOGIC;
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
		
		--from EMRegister
		PCaddress_exmem : in STD_LOGIC_VECTOR(15 downto 0);
		data_exmem : in STD_LOGIC_VECTOR(15 downto 0);
		MemWrite_exmem : in STD_LOGIC;
		MemRead_exmem : in STD_LOGIC;
		
		datatoexmem : out STD_LOGIC_VECTOR(15 DOWNTO 0);
		
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

signal	pcchooseout : STD_LOGIC_VECTOR(15 downto 0); 
--PCRegister signal
signal pcregisterout : STD_LOGIC_VECTOR(15 downto 0);
signal isbubble_pcregister : STD_LOGIC;
signal pcaddout : STD_LOGIC_VECTOR(15 downto 0);

begin
	isbubble_pcregister <= isbubble_pc_fd or isbubble_pc_fd_de;
	pcin_fd <= pcaddout;
		--PCChoose port map
	PCChoose_comp:PCChoose port map(
			PCSrc => pcsrc,
	      	PCadd1 => pcaddout,
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
			
			--from EMRegister
			PCaddress_exmem => ALUresultout_exmem,
			data_exmem => data2out_exmem,
			MemWrite_exmem => memwriteout_exmem,
			MemRead_exmem => memreadout_exmem,
			
			datatoexmem => datafrompcmem_pcmem,
			
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
			PCout => pcaddout
		);

end Behavior;