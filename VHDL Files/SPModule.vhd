Library ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith;

Entity SPModule is
Port(
MemWrite, SPSel: in std_logic;
OldSP : in std_logic_vector(15 downto 0);
NewSP, PipeSP : out std_logic_vector(15 downto 0));
End Entity SPModule;

Architecture SPModule_Arch of SPModule is
Begin

	PipeSP <= OldSP 	  when SPSel = '1' and MemWrite = '1' else	--Push
	 	  OldSP + x"0001" when SPSel = '1' and MemWrite = '0' else	--Pop
		  OldSP;

	NewSP  <= OldSP - x"0001" when SPSel = '1' and MemWrite = '1' else	--Push
		  OldSP + x"0001" when SPSel = '1' and MemWrite = '0' else	--Pop
		  OldSP;

End Architecture SPModule_Arch;