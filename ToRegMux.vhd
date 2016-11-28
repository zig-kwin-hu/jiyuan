library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity ToRegMux is
	Port(
			MemToReg : in STD_LOGIC_Vector(1 downto 0);
			MemResult : in STD_LOGIC_Vector(15 downto 0);
			ALUResult : in STD_LOGIC_Vector(15 downto 0);
			RegResult : in STD_LOGIC_Vector(15 downto 0);
			Result : out STD_LOGIC_Vector(15 downto 0)
		);
end ToRegMux;

architecture Behavior of ToRegMux is
begin
	process(MemtoReg, MemResult, ALUResult, RegResult)
	begin
		if(MemToReg="00") then
			Result <= MemResult;
		elsif (MemToReg="01") then
			Result <= ALUResult;
		else
			Result <= RegResult;
		end if;		
	end process;
end Behavior;