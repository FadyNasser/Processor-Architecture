library ieee;
use ieee.std_logic_1164.all;

entity LU_PartA is
port(A,B : in std_logic_vector(15 downto 0); Cin : in std_logic; S : in std_logic_vector(1 downto 0); F : out std_logic_vector(15 downto 0); Cout : out std_logic; Overflow : out std_logic);
end entity LU_PartA;

architecture LU_PartA_Arch of LU_PartA is

component FA is
generic (n: integer := 8);
port(A, B : in std_logic_vector(n-1 downto 0); Cin : in std_logic; F : out std_logic_vector(n-1 downto 0); Cout : out std_logic; Overflow : out std_logic);
end component FA;

signal FA_InB, FA_InA : std_logic_vector(15 downto 0);
signal FA_Cout : std_logic;
signal FA_OF : std_logic;
Begin
	U1: FA generic map(n => 16) port map(FA_InA, FA_InB, Cin, F, FA_Cout, FA_OF);

		FA_InB <= (others => '0')	when S="00" and Cin = '0' else	--Transfer A
			 B			when S="00" and Cin = '1' else	--Inc B
			 B	 		when S="01"   else		--A+B
			 not B			when S="10"   else		--A-B
			 B			when S="11" and Cin = '0' else	--B-1
			 not B			when S="11" and Cin = '1';	--NEG B

		FA_InA <= A			when S="00" and Cin = '0' else	--Transfer A
			 (others => '0')	when S="00" and Cin = '1' else	--Inc B
			 A	 		when S="01"   else		--A+B
			 A			when S="10"   else		--A-B
			 (others => '1')	when S="11" and Cin = '0' else	--B-1
			 (others => '0')	when S="11" and Cin = '1';	--NEG B
		
		Cout <= FA_Cout when S="00" or S="01" else
			not FA_Cout;
		
		Overflow <= FA_OF;
end architecture LU_PartA_Arch;