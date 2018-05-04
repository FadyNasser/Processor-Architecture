Library ieee;
Use ieee.std_logic_1164.all;

entity FU is
port( 	ExMem_Rdst, IdEx_Rsrc, IdEx_Rdst, MemWB_Rdst : in std_logic_vector (2 downto 0);
	ExMem_RegWrite, MemWB_RegWrite : in std_logic;
	MUX_A, MUX_B : out std_logic_vector(1 downto 0));
end FU;

Architecture FU_Arch of FU is

Begin

	MUX_A <= "01" When ExMem_RegWrite = '1' and ExMem_Rdst = IdEx_Rsrc else	--ALU to ALU
		 "00" When MemWB_RegWrite = '1' and MemWB_Rdst = IdEX_Rsrc else	--Mem to ALU
		 "10";	--Default
	
	MUX_B <= "01" When ExMem_RegWrite = '1' and ExMem_Rdst = IdEx_Rdst else	--ALU to ALU
		 "00" When MemWB_RegWrite = '1' and MemWB_Rdst = IdEX_Rdst else	--Mem to ALU
		 "10";	--Default

End Architecture FU_Arch;
