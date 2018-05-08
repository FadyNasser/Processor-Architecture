Library ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith;

Entity SPModule is
Port(
Clk, Reset, MemWrite, SPSel: in std_logic;
PipeSP : out std_logic_vector(15 downto 0));
End Entity SPModule;

Architecture SPModule_Arch of SPModule is
signal SP, NewSP : std_logic_vector(15 downto 0);

Begin
	process(Clk, Reset, SPSel, MemWrite) is
	begin
		if Reset = '1'  then
			SP <= x"FFFF";
		elsif rising_edge(Clk) then
			SP <= NewSP;
		end if;
	end process;

	PipeSP <= SP 	  when SPSel = '1' and MemWrite = '1' else	--Push
	 	  SP + x"0001" when SPSel = '1' and MemWrite = '0' else	--Pop
		  SP;

	NewSP  <= SP - x"0001" when SPSel = '1' and MemWrite = '1' else	--Push
		  SP + x"0001" when SPSel = '1' and MemWrite = '0' else	--Pop
		  SP;

End Architecture SPModule_Arch;
