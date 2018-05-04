library ieee;
use ieee.std_logic_1164.all;

entity FA_OneBit is
port(A, B, Cin : in std_logic; F : out std_logic; Cout : out std_logic);
end entity FA_OneBit;

architecture FA_OneBit_Arch of FA_OneBit is
Begin
	F <= A xor B xor Cin;
	Cout <= (Cin and (A xor B)) or (A and B);
end architecture FA_OneBit_Arch;