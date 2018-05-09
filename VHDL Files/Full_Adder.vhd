library ieee;
use ieee.std_logic_1164.all;

entity FA is
generic (n: integer := 8);
port(A, B : in std_logic_vector(n-1 downto 0); Cin : in std_logic; F : out std_logic_vector(n-1 downto 0); Cout : out std_logic; Overflow : out std_logic);
end entity FA;

architecture FA_Arch of FA is

component FA_OneBit is
port(A, B, Cin : in std_logic; F : out std_logic; Cout : out std_logic);
end component FA_OneBit;

signal tempCout : std_logic_vector(n-1 downto 0);
signal tempoverflow : std_logic_vector(n-1 downto 0);
Begin
	A0: FA_OneBit port map(A(0), B(0), Cin, F(0), tempCout(0));
	loop1: for i in 1 to n-1 generate
		Ax: FA_OneBit port map(A(i), B(i), tempCout(i-1), F(i), tempCout(i));
		tempoverflow(i) <= tempCout(i-1) xor tempCout(i);
	end generate;
	
	Cout <= tempCout(n-1);
	OverFlow <= tempoverflow(n-1);
end architecture FA_Arch;