library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity PCAdd1 is
	port(
			PCin : in STD_LOGIC_VECTOR(15 downto 0);
			PCout : out STD_LOGIC_VECTOR(15 downto 0)
		);
end PCAdd1;

architecture Behavior of PCAdd1 is
	begin
	PCout <= PCin + "0000000000000001";
end Behavior;