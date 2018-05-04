library ieee;
use ieee.std_logic_1164.all;

entity ALU is
port(A,B : in std_logic_vector(15 downto 0); Shift : in std_logic_vector(3 downto 0); Cin : in std_logic; S : in std_logic_vector(3 downto 0); F : out std_logic_vector(15 downto 0); 
Cout, Zero, Neg, Overflow : out std_logic);
end entity ALU;

architecture ALU_Arch of ALU is

Signal FA, FB, FC, FD : std_logic_vector(15 downto 0);
Signal CoutA, CoutB, CoutC, CoutD : std_logic;

component LU_PartA is
port(A,B : in std_logic_vector(15 downto 0); Cin : in std_logic; S : in std_logic_vector(1 downto 0); F : out std_logic_vector(15 downto 0); Cout : out std_logic);
end component LU_PartA;

component LU_PartB is
port(A,B : in std_logic_vector(15 downto 0); Cin : in std_logic; S : in std_logic_vector(1 downto 0); F : out std_logic_vector(15 downto 0); Cout : out std_logic);
end component LU_PartB;

component LU_PartC is
port(A, B : in std_logic_vector(15 downto 0); Shift : in std_logic_vector(3 downto 0); Cin : in std_logic; S : in std_logic_vector(1 downto 0); F : out std_logic_vector(15 downto 0); Cout : out std_logic);
end component LU_PartC;

component LU_PartD is
port(A, B : in std_logic_vector(15 downto 0); Shift : in std_logic_vector(3 downto 0); Cin : in std_logic; S : in std_logic_vector(1 downto 0); F : out std_logic_vector(15 downto 0); Cout : out std_logic);
end component LU_PartD;

Begin
	PartA: LU_PartA port map(A, B, Cin, S(1 downto 0), FA, CoutA);
	PartB: LU_PartB port map(A, B, Cin, S(1 downto 0), FB, CoutB);
	PartC: LU_PartC port map(A, B, Shift, Cin, S(1 downto 0), FC, CoutC);
	PartD: LU_PartD port map(A, B, Shift, Cin, S(1 downto 0), FD, CoutD);

	with S(3 downto 2) select
		F <= 	FA when "00",
			FB when "01",
			FC when "10",
			FD when others;

	with S(3 downto 2) select
		Cout <= CoutA	when "00",
			CoutB	when "01",
			CoutC	when "10",
			CoutD 	when "11",
			'0' 	when others;

		Zero <= '1' when (S(3 downto 2) = "00" and FA = x"0000") or
				 (S(3 downto 2) = "01" and FB = x"0000") or
				 (S(3 downto 2) = "10" and FC = x"0000") or
				 (S(3 downto 2) = "11" and FD = x"0000") else
			'0';

	with S(3 downto 2) select
		Neg <= 	FA(15) when "00",
			FB(15) when "01",
			FC(15) when "10",
			FD(15) when others;

	--Overflow is still yet to be implemented!!

end architecture ALU_Arch;