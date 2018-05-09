Library ieee;
Use ieee.std_logic_1164.all;

entity PCModule is
port( 	Interrupt, Reset, Clk, PCSrc, CallSel, PCFreeze, PCWrite : in std_logic;
	RdstVal, WriteData : in std_logic_vector(15 downto 0);
	Flush_IdEx : out std_logic;
	Instruction, PC, Imm : out std_logic_vector (15 downto 0));
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


	signal PCSig, NewPCSig, Instr, InstrBuffer : std_logic_vector(15 downto 0);
	signal IsInterrupt, IsReset, IsImmediate, FA_Cout, Flush, ImmFlush, NextFlush : std_logic;
Begin	
	InstrMem: Memory port map(Clk, '0', x"0000", Instr, PCSig(9 downto 0));
	PCSig_Adder: FA generic map(n => 16) port map(x"0000", PCSig, '1', NewPCSig, FA_Cout);

	process(Clk, Reset, Interrupt)
	begin
	if rising_edge(Clk) then
		if Flush = '1' then
			Flush <= '0';

		end if;

		if NextFlush = '1' then
			NextFlush <= '0';
		end if;

		if Reset = '1' then
			PC <= x"0000";
			PCSig <= x"0000";
			IsReset <= '1';
			
		elsif IsReset = '1' then
			PC <= Instr;
			PCSig <= Instr;
			
			IsReset <= '0';
			Flush <= '1';

		elsif Interrupt = '1' then
			PC <= PCSig;
			PCSig <= x"0001";
			IsInterrupt <= '1';
		elsif IsInterrupt = '1' then 
			PC <= Instr;
			PCSig <= Instr;
			IsInterrupt <= '0';
			NextFlush <= '1';
		else
			if PCFreeze = '0' then
				if PCWrite = '1' then
					PC <= WriteData;
					PCSig <= WriteData;					
				else
					if CallSel = '0' then
						if PCSrc = '0' then
							PC <= NewPCSig;
							PCSig <= NewPCSig;
						
						else
							PC <= RdstVal;
							PCSig <= RdstVal;							
						end if;
					else
						PC <= RdstVal;
						PCSig <= RdstVal;
					end if;
				end if;
			end if;
		end if;
	end if;
	end process;
	process(Clk, Reset) is
	begin
		if Reset = '1' then
			IsImmediate <= '0';
			ImmFlush <= '0';
		elsif rising_edge(Clk) then
			if ImmFlush = '1' then
				ImmFlush <= '0';
			end if;

			if IsImmediate = '0' then
				if Instr(15 downto 11) = "11011" or Instr(15 downto 11) = "11100" or Instr(15 downto 11) = "11101" then
					IsImmediate <= '1';
					InstrBuffer <= Instr;
					ImmFlush <= '1';
				end if;
			elsif IsImmediate = '1' then
				IsImmediate <= '0';
			end if; 
		end if;
	end process;

	Flush_IdEx <= '1' when Flush = '1' or CallSel = '1' or PCSrc = '1' or ImmFlush ='1' or NextFlush = '1' else
		      '0'; 
	Imm <= Instr when IsImmediate = '1' else x"0000";
	Instruction <= InstrBuffer when IsImmediate = '1' else Instr;

End Architecture PCModule_Arch;
