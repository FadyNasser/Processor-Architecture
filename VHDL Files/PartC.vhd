library ieee;
use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

entity LU_PartC is
port(A,B : in std_logic_vector(15 downto 0); Shift : in std_logic_vector(3 downto 0); Cin : in std_logic; S : in std_logic_vector(1 downto 0); F : out std_logic_vector(15 downto 0); Cout : out std_logic);
end entity LU_PartC;

architecture LU_PartC_Arch of LU_PartC is
signal N : integer;
Begin
	N <= to_integer(unsigned(Shift));
	with S select
		F <= 	std_logic_vector(shift_right(unsigned(A), N)) when "00",	--Logic Shift Right
			B(0)  & B(15 downto 1) 	when "01",				--Rotate Right
			Cin   & B(15 downto 1)	when "10",				--Rotate Right with Carry
			A(15) & A(15 downto 1)	when others;				--Arithmetic Shift Right
	Cout <= B(0) when S = "10" else A(0);
end architecture LU_PartC_Arch;