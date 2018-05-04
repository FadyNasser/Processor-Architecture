Library ieee;
USE ieee.std_logic_1164.ALL;

Entity CU is
Port(
OPCode	: in std_logic_vector(4 downto 0);
Int	: in std_logic;
JZ, JN, JC, JMP, ALUSrc, ALUCin, SETC, CLRC, MemWrite, MemRead, RegWrite, MemToReg, PortSelect, PortWrite, SPSel,
PCWrite, MemPC, CallSel, WriteCCR, ReadImm: out std_logic);
End Entity CU;

Architecture CU_Arch of CU is
signal OP : std_logic_vector(4 downto 0);
Begin
	OP <= OPCode when Int = '0' else "00000";
	JZ	   <= '1' when OP = "10100" else '0';
	JN	   <= '1' when OP = "10101" else '0';
	JC 	   <= '1' when OP = "10110" else '0';
	JMP	   <= '1' when OP = "10111" else '0';

	ALUSrc	   <= '0' when OP = "00000" or OP = "01000" or OP = "01001" or OP = "11011" or OP = "11100" or OP = "11101" or Int = '1' else '1';
	ALUCin	   <= '1' when OP = "00110" or OP = "00111" else '0';

	SETC	   <= '1' when OP = "01010" else '0';
	CLRC	   <= '1' when OP = "01011" else '0';

	MemWrite   <= '1' when OP = "01100" or OP = "11000" or OP = "11101" or Int = '1' else '0';
	MemRead    <= '1' when OP = "01101" or OP = "11001" or OP = "11010" or OP = "11100" else '0';

	RegWrite   <= '0' when OP = "00000" or OP = "01010" or OP = "01011" or OP = "01100" or OP = "01110" or OP = "10100" or OP = "10101" or
			     OP = "10110" or OP = "10111" or OP = "11000" or OP = "11001" or OP = "11010" or OP = "11101" or Int = '1' else '1';
	MemToReg   <= '0' when OP = "00000" or OP = "01101" or OP = "11001" or OP = "11010" or OP = "11100" or Int='1' else '1';
	
	PortSelect <= '1' when OP = "01111" else '0';
	PortWrite  <= '1' when OP = "01110" else '0';

	SPSel	   <= '1' when OP = "01100" or OP = "01101" or OP = "11000" or OP = "11001" or OP = "11010" or Int = '1' else '0';

	PCWrite	   <= '1' when OP = "11000" or OP = "11001" or OP = "11010" or Int = '1' else '0';

	MemPC	   <= '1' when OP = "11000" or Int = '1' else '0';
	
	CallSel	   <= '1' when OP = "11000" else '0';

	WriteCCR   <= '1' when OP = "11010" else '0';

	ReadImm	   <= '1' when OP = "11011" or OP = "11100" or OP = "11101" else '0';

End Architecture CU_Arch;