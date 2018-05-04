library ieee;
use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

entity LU_PartD is
port(A, B : in std_logic_vector(15 downto 0); Shift : in std_logic_vector(3 downto 0); Cin : in std_logic; S : in std_logic_vector(1 downto 0); F : out std_logic_vector(15 downto 0); Cout : out std_logic);
end entity LU_PartD;

architecture LU_PartD_Arch of LU_PartD is
signal N : integer;
Begin
	N <= to_integer(unsigned(Shift));
	with S select
		F <= 	std_logic_vector(shift_left(unsigned(A), N)) when "00",		--Logic Shift Left
			B(14 downto 0) & B(15) 	when "01",				--Rotate Left
			B(14 downto 0) & Cin	when "10",				--Rotate Left with Carry
			B			when others;				--F=B
	with S select
		Cout <= '0'	when "11",
			B(15)	when "10",
			A(15)	when others;
end architecture LU_PartD_Arch;