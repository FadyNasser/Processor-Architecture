Library ieee;
USE ieee.std_logic_1164.ALL;

Entity BranchModule is
Port(
Cout, JC, Zero, JZ, Neg, JN, JMP : in std_logic;
RstC, RstZ, RstN, PCSrc : out std_logic);
End Entity BranchModule;

Architecture BranchModule_Arch of BranchModule is
Begin
	RstC <= Cout and JC;
	RstZ <= Zero and JZ;
	RstN <= Neg  and JN;

	PCSrc <= JMP or ( (Neg and JN) or ( (Zero and JZ) or (Cout and JC) ) );

End Architecture BranchModule_Arch;
