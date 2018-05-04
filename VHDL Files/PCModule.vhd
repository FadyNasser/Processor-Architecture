Library ieee;
Use ieee.std_logic_1164.all;

entity PCModule is
port( 	Interrupt, Reset, Clk, PCSrc, CallSel, PCFreeze, PCWrite : in std_logic;
	RdstVal, WriteData : in std_logic_vector(15 downto 0);
	Flush_IfId : out std_logic;
	Instruction : out std_logic_vector (15 downto 0));
end PCModule;

Architecture PCModule_Arch of PCModule is

component Memory is
generic(n:integer:=10; m:integer:=16);
port( Clk, MemWrite : in std_logic;
Write_Data : in std_logic_vector (m-1 downto 0);
Read_Data : out std_logic_vector (m-1 downto 0);
Address : in std_logic_vector(n-1 downto 0));
end component;

component FA is
generic (n: integer := 8);
port(A, B : in std_logic_vector(n-1 downto 0); Cin : in std_logic; F : out std_logic_vector(n-1 downto 0); Cout : out std_logic);
end component FA;


	signal PC, NewPC, Instr : std_logic_vector(15 downto 0);
	signal IsInterrupt, IsReset, FA_Cout, Flush : std_logic;
Begin	
	InstrMem: Memory port map(Clk, '0', x"0000", Instr, PC(9 downto 0));
	PC_Adder: FA generic map(n => 16) port map(x"0000", PC, '1', NewPC, FA_Cout);

	process(Clk, Reset, Interrupt)
	begin
		if Flush = '1' and rising_edge(Clk) then
			Flush <= '0';
		end if;

		if Reset = '1' then
			PC <= x"0000";
			IsReset <= '1';
		elsif IsReset = '1' then
			PC <= Instr;
			IsReset <= '0';
			Flush <= '1';

		elsif Interrupt = '1' then
			PC <= x"0001";
			IsInterrupt <= '1';
		elsif IsInterrupt = '1' then
			PC <= Instr;
			IsInterrupt <= '0';
			Flush <= '1';
		else
			if rising_edge(Clk) and PCFreeze = '0' then
				if PCWrite = '1' then
					PC <= WriteData;
				else
					if CallSel = '0' then
						if PCSrc = '0' then
							PC <= NewPC;
						else
							PC <= RdstVal;
						end if;
					else
						PC <= RdstVal;
					end if;
				end if;
			end if;
		end if;
		
	end process;

	Flush_IfId <= '1' when Flush = '1' or CallSel = '1' or PCSrc = '1' else
		      '0'; 
	Instruction <= Instr;

End Architecture PCModule_Arch;
