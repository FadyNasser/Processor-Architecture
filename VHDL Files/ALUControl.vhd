
Library ieee;
USE ieee.std_logic_1164.ALL;

Entity ALU_CU is
Port(
OPCode	: in std_logic_vector(4 downto 0);
ALUCode	: out std_logic_vector(3 downto 0);
ALUCin : out std_logic);
End Entity ALU_CU;

Architecture ALU_CU_Arch of ALU_CU is
Begin
	ALUCode <= "0000" when OPCode = "00001" else	--MOV --Output is the Rsrc Value
		   "0001" when OPCode = "00010" else	--Add
		   "0010" when OPCode = "00011" else	--Sub
		   "0100" when OPCode = "00100" else	--AND
		   "0101" when OPCode = "00101" else	--OR
		   "1110" when OPCode = "00110" else	--RLC
		   "1010" when OPCode = "00111" else	--RRC
		   "1100" when OPCode = "01000" else	--SHL
		   "1000" when OPCode = "01001" else	--SHR
		   "0111" when OPCode = "10000" else	--NOT
		   "0011" when OPCode = "10001" else 	--Neg
		   "0000" when OPCode = "10010" else	--INC
		   "0011" when OPCode = "10011" else	--DEC
		   "1111"; --Output is the Rdst Value

	ALUCin <= '1' when OPCode = "00011" or OPCode = "10010" or OPCode = "10001" else '0';

End Architecture ALU_CU_Arch;