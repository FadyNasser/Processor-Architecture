library ieee;
use ieee.std_logic_1164.all;

entity LU_PartB is
port(A,B : in std_logic_vector(15 downto 0); Cin : in std_logic; S : in std_logic_vector(1 downto 0); F : out std_logic_vector(15 downto 0); Cout : out std_logic);
end entity LU_PartB;

architecture LU_PartB_Arch of LU_PartB is

component FA is
generic (n: integer := 8);
port(A, B : in std_logic_vector(n-1 downto 0); Cin : in std_logic; F : out std_logic_vector(n-1 downto 0); Cout : out std_logic);
end component FA;

signal FA_In : std_logic_vector(15 downto 0);

Begin
	U1: FA generic map(n => 16) port map(FA_In, x"0000", Cin, F, Cout);

	with S select
		FA_In <= 	A and	B when "00",	--And
				A or	B when "01",	--OR
				A xor	B when "10",	--XOR
			 	  not	A when others;	--NOT
end architecture LU_PartB_Arch;