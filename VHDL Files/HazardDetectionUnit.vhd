Library ieee;
Use ieee.std_logic_1164.all;

entity HDU is
port( 	IdEx_MemRead : in std_logic;
	IfId_Rdst, IdEx_Rdst : in std_logic_vector (2 downto 0);
	Flush, PCFreeze : out std_logic);
end HDU;

Architecture HDU_Arch of HDU is

Begin
	Flush <= '1' when IdEx_MemRead = '1' and IfId_Rdst = IdEx_Rdst else
		 '0';

	PCFreeze <= '1' when IdEx_MemRead = '1' and IfId_Rdst = IdEx_Rdst else
		    '0';

End Architecture HDU_Arch;