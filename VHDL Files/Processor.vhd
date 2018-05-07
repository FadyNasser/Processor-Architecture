Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith;

Entity Processor is
port(	
	Interrupt, Reset, Clk : in std_logic
	--WriteData : in std_logic_vector(15 downto 0)
    );
end Processor;

Architecture Pipelined_Processor of Processor is
----------------------------------------------------------------------------------------------------------------------------------
--1)Components :-
------------------

Component ALU is
port(A,B : in std_logic_vector(15 downto 0); Shift : in std_logic_vector(3 downto 0); Cin : in std_logic; S : in std_logic_vector(3 downto 0); F : out std_logic_vector(15 downto 0); 
Cout, Zero, Neg, Overflow : out std_logic);
end Component ALU;

Component ALU_CU is
Port(
OPCode	: in std_logic_vector(4 downto 0);
ALUCode	: out std_logic_vector(3 downto 0);
ALUCin : out std_logic);
End Component ALU_CU;

Component BranchModule is
Port(
Cout, JC, Zero, JZ, Neg, JN, JMP : in std_logic;
RstC, RstZ, RstN, PCSrc : out std_logic);
End Component BranchModule;

Component entityCCR is
port( Clk, RST, WriteCCR, SETC, CLRC, CoutAlu, ZeroAlu, NegAlu, OverflowAlu: in std_logic;
CoutTempCCR, ZeroTempCCR, NegTempCCR, OvervlowTempCCR: in std_logic;
Cout, Zero, Neg, Overflow: out std_logic);
end Component entityCCR;

Component CU is
Port(
OPCode	: in std_logic_vector(4 downto 0);
Int	: in std_logic;
JZ, JN, JC, JMP, ALUSrc, ALUCin, SETC, CLRC, MemWrite, MemRead, RegWrite, MemToReg, PortSelect, PortWrite, SPSel,
PCWrite, MemPC, CallSel, WriteCCR, ReadImm: out std_logic);
End Component CU;

Component FU is
port( 	ExMem_Rdst, IdEx_Rsrc, IdEx_Rdst, MemWB_Rdst : in std_logic_vector (2 downto 0);
	ExMem_RegWrite, MemWB_RegWrite : in std_logic;
	MUX_A, MUX_B : out std_logic_vector(1 downto 0));
end Component FU;

Component FA is
generic (n: integer := 8);
port(A, B : in std_logic_vector(n-1 downto 0); Cin : in std_logic; F : out std_logic_vector(n-1 downto 0); Cout : out std_logic);
end Component FA;

Component FA_OneBit is
port(A, B, Cin : in std_logic; F : out std_logic; Cout : out std_logic);
end Component FA_OneBit;

Component HDU is
port( 	IdEx_MemRead : in std_logic;
	IfId_Rdst, IdEx_Rdst : in std_logic_vector (2 downto 0);
	Flush, PCFreeze : out std_logic);
end Component HDU;

Component Memory is
generic(n:integer:=10; m:integer:=16);
port( Clk, MemWrite : in std_logic;
Write_Data : in std_logic_vector (m-1 downto 0);
Read_Data : out std_logic_vector (m-1 downto 0);
Address : in std_logic_vector(n-1 downto 0));
end Component Memory;

Component PCModule is
port( 	Interrupt, Reset, Clk, PCSrc, CallSel, PCFreeze, PCWrite : in std_logic;
	RdstVal, WriteData : in std_logic_vector(15 downto 0);
	Flush_IfId : out std_logic;
	Instruction, PC : out std_logic_vector (15 downto 0));
end Component PCModule;

Component entityPort is
port( Clk, PortWrite: in std_logic;
RegValueIn: in std_logic_vector(15 downto 0);
RegValueOut: out std_logic_vector(15 downto 0);
inPort: in std_logic_vector(15 downto 0);
outPort: out std_logic_vector(15 downto 0));
end Component entityPort;

Component my_DFF is
Generic ( n : integer := 16);
port( Clk,Rst, En : in std_logic;
d : in std_logic_vector(n-1 downto 0);
q : out std_logic_vector(n-1 downto 0));
end component my_DFF;

Component Registers is
port( Clk, Rst, RegWrite : in std_logic;
Write_Reg, Reg_1, Reg_2 : in std_logic_vector (2 downto 0);
Data_1, Data_2 : out std_logic_vector (15 downto 0);
Write_Data : in std_logic_vector(15 downto 0));
end Component Registers;

Component SPModule is
Port(
MemWrite, SPSel: in std_logic;
OldSP : in std_logic_vector(15 downto 0);
NewSP, PipeSP : out std_logic_vector(15 downto 0));
End Component SPModule;

----------------------------------------------------------------------------------------------------------------------------------
--2)Signals :-
--------------

--IF/ID Signals :-
-------------------
signal Int : std_logic;					-- 47
signal Op : std_logic_vector(4 downto 0); 		-- 46:42 
signal Imm : std_logic_vector(15 downto 0); 		-- 41:26
signal Shift : std_logic_vector(3 downto 0);		-- 25:22
signal Rdst : std_logic_vector(2 downto 0); 		-- 21:19
signal Rsrc : std_logic_vector(2 downto 0); 		-- 18:16
signal Pc : std_logic_vector(15 downto 0); 		-- 15:0
signal IF_ID : std_logic_vector(47 downto 0); 		-- 48 bits


--ID/EX Signals :-
-------------------
signal RegData1 : std_logic_vector(15 downto 0);	-- 128:113
signal RegData2 : std_logic_vector(15 downto 0);	-- 112:97
--signal Imm : std_logic_vector(15 downto 0);		-- 96:81
--signal Pc : std_logic_vector(15 downto 0);		-- 80:65
signal Sp : std_logic_vector(15 downto 0);		-- 64:49
signal PortVal : std_logic_vector(15 downto 0);		-- 48:33
--signal Op : std_logic_vector(4 downto 0);		-- 32:28
--signal Shift : std_logic_vector(3 downto 0);		-- 27:24
--signal Rdst : std_logic_vector(2 downto 0);		-- 23:21
--signal Rsrc : std_logic_vector(2 downto 0);		-- 20:18
signal Jz : std_logic;					-- 17
signal Jn : std_logic;					-- 16
signal Jc : std_logic;					-- 15
signal Jmp : std_logic;					-- 14
signal ALUSrc : std_logic;				-- 13
signal ALUCin : std_logic;				-- 12
signal ClrC : std_logic;				-- 11
signal SetC : std_logic;				-- 10
signal WriteCcr : std_logic;				-- 9
signal PortSelect : std_logic;				-- 8
signal MemWrite : std_logic;				-- 7
signal SpSel : std_logic;				-- 6
signal CallSel : std_logic;				-- 5
signal MemPc : std_logic;				-- 4
signal MemToReg : std_logic;				-- 3
signal PortWrite : std_logic;				-- 2
signal PcWrite : std_logic;				-- 1
signal RegWrite : std_logic; 				-- 0
signal ID_Ex : std_logic_vector(128 downto 0);		-- 129 bits


--EX/Mem Signals :-
--------------------
signal Result_PortVal : std_logic_vector(15 downto 0);	-- 74:59
--signal RegData2 : std_logic_vector(15 downto 0);	-- 58:43
--signal Pc : std_logic_vector(15 downto 0);		-- 42:27
--signal Sp : std_logic_vector(15 downto 0);		-- 26:11
--signal Rdst : std_logic_vector(2 downto 0);		-- 10:8
--signal MemWrite : std_logic;				-- 7
--signal SpSel : std_logic;				-- 6
--signal CallSel : std_logic;				-- 5
--signal MemPc : std_logic;				-- 4
--signal MemToReg : std_logic;				-- 3
--signal PortWrite : std_logic;				-- 2
--signal PcWrite : std_logic;				-- 1
--signal RegWrite : std_logic;				-- 0
signal Ex_Mem : std_logic_vector(74 downto 0);		-- 75 bits


-- Mem/WB Signals :-
---------------------
--signal PortVal : std_logic_vector(15 downto 0);	-- 38:23
signal ReadData : std_logic_vector(15 downto 0);	-- 22:7
--signal Rdst :std_logic_vector(2 downto 0);		-- 6:4
--signal MemToReg : std_logic;				-- 3
--signal PortWrite : std_logic;				-- 2
--signal PcWrite : std_logic;				-- 1
--signal RegWrite : std_logic;				-- 0
signal Mem_WB : std_logic_vector(38 downto 0);		-- 39 bits

----------------------------------------------------------------------------------------------------------------------------------
--4)Registers Signals :-
------------------------
signal R1_En, R2_En, R3_En ,R4_En : std_logic;
signal R1_In, R1_Out : std_logic_vector(47 downto 0);
signal R2_In, R2_Out : std_logic_vector(128 downto 0);
signal R3_In, R3_Out : std_logic_vector(74 downto 0);
signal R4_In, R4_Out : std_logic_vector(38 downto 0);
----------------------------------------------------------------------------------------------------------------------------------
--5)Stages Signals :-
---------------------

--a)Fetch Signals :- "PC Module"
--------------------------------
signal PCSrc, PCFreeze : std_logic;
signal RdstVal, WriteData : std_logic_vector(15 downto 0);
signal Flush_IfId : std_logic;
signal Instruction : std_logic_vector (15 downto 0);
signal PC_Out : std_logic_vector (15 downto 0);

--b)Decode Signals :- 
----------------------


--c)Execute Signals :- 
-----------------------


--d)Memory Signals :- 
----------------------


--e)WriteBack Signals :- 
-------------------------


----------------------------------------------------------------------------------------------------------------------------------

begin

--Initial Values:-
-------------------

R1_En <= '1';
R2_En <= '1';
R3_En <= '1';
R4_En <= '1';

----------------------------------------------------------------------------------------------------------------------------------
--1)Fetch :-
-------------

PC_Module : PCModule port map(Interrupt, Reset, Clk, PCSrc, CallSel, PCFreeze, PCWrite ,RdstVal, WriteData, Flush_IfId, Instruction,PC_Out);

Op <= Instruction(15 downto 11);
Rsrc <= Instruction(10 downto 8);
Rdst <= Instruction(7 downto 5);
Shift <= Instruction(3 downto 0);
Int <= Interrupt;
Pc <= PC_Out;
--Imm <= ;

-----------------------------------------------------------------------------------------------------------------------------------
--IF/ID Reg :-
---------------
IF_ID <= Int & Op(4 downto 0) & Imm(15 downto 0) & Shift(3 downto 0) & Rdst(2 downto 0) & Rsrc(2 downto 0) & Pc(15 downto 0);
R1_In <= IF_ID;
R1: my_DFF generic map(n => 48) port map(Clk, Reset, R1_En, R1_In, R1_Out);
----------------------------------------------------------------------------------------------------------------------------------
--2)Decode :-
--------------
--Int <= R1_Out(47);
--Op <= R1_Out(46 downto 42);
--Imm <= R1_Out(41 downto 26);
--Shift <= R1_Out(25 downto 22);
--Rdst <= R1_Out(21 downto 19);
--Rsrc <= R1_Out(18 downto 16);
--Pc <= R1_Out(15 downto 0);


--RegData1 <= ;
--RegData2 <= ;
--Sp <= ;
--PortVal <= ;
--Jz <= ;
--Jn <= ;
--Jc <= ;
--Jmp <= ;
--ALUSrc <= ;
--ALUCin <= ;
--ClrC <= ;
--SetC <= ;
--WriteCcr <= ;
--PortSelect <= ;
--MemWrite <= ;
--SpSel <= ;
--CallSel <= ;
--MemPc <= ;
--MemToReg <= ;
--PortWrite <= ;
--PcWrite <= ;
--RegWrite <= ;


----------------------------------------------------------------------------------------------------------------------------------
--ID/EX Reg :-
-----------------
--ID_EX <= RegData1(15 downto 0) & RegData2(15 downto 0) & Imm(15 downto 0) & Pc(15 downto 0) & Sp(15 downto 0) & PortVal(15 downto 0) & Op(4 downto 0) &  Shift(3 downto 0) & Rdst(2 downto 0) & Rsrc(2 downto 0) & Jz & Jn & Jc & Jmp & ALUSrc & ALUCin & ClrC & SetC & WriteCcr & PortSelect & MemWrite & SpSel & CallSel & MemPc & MemToReg & PortWrite & PcWrite & RegWrite;
ID_EX <= RegData1(15 downto 0) & RegData2(15 downto 0) & R1_Out(41 downto 26) & R1_Out(15 downto 0) & Sp(15 downto 0) & PortVal(15 downto 0) & R1_Out(46 downto 42) & R1_Out(25 downto 22) & R1_Out(21 downto 19) & R1_Out(18 downto 16) & Jz & Jn & Jc & Jmp & ALUSrc & ALUCin & ClrC & SetC & WriteCcr & PortSelect & MemWrite & SpSel & CallSel & MemPc & MemToReg & PortWrite & PcWrite & RegWrite;
R2_In <= ID_EX;
R2: my_DFF generic map(n => 129) port map(Clk, Reset, R2_En, R2_In, R2_Out);
----------------------------------------------------------------------------------------------------------------------------------
--3)Execute :-
---------------
--RegData1 <= R2_Out(128 downto 113);
--RegData2 <= R2_Out(112 downto 97);
--Imm <= R2_Out(96 downto 81);	
--Pc <= R2_Out(80 downto 65);
--Sp <= R2_Out(64 downto 49);
--PortVal <= R2_Out(48 downto 33);
--Op <= R2_Out(32 downto 28);
--Shift <= R2_Out(27 downto 24);
--Rdst <= R2_Out(23 downto 21);
--Rsrc <= R2_Out(20 downto 18);
--Jz <= R2_Out(17);
--Jn <= R2_Out(16);
--Jc <= R2_Out(14);
--Jmp <= R2_Out(14);
--ALUSrc <= R2_Out(13);
--ALUCin <= R2_Out(12);
--ClrC <= R2_Out(11);
--SetC <= R2_Out(10);
--WriteCcr <= R2_Out(9);
--PortSelect <= R2_Out(8);
--MemWrite <= R2_Out(7);
--SpSel <= R2_Out(6);
--CallSel <= R2_Out(5);
--MemPc <= R2_Out(4);
--MemToReg <= R2_Out(3);
--PortWrite <= R2_Out(2);
--PcWrite <= R2_Out(1);
--RegWrite <= R2_Out(0);


--Result_PortVal <=;


----------------------------------------------------------------------------------------------------------------------------------
--EX/Mem Reg :-
-----------------
--Ex_Mem <= PortVal(15 downto 0) & RegData2(15 downto 0) & Pc(15 downto 0) & Sp(15 downto 0) & Rdst(2 downto 0) & MemWrite & SpSel & CallSel & MemPc & MemToReg & PortWrite & PcWrite & RegWrite;
Ex_Mem <= Result_PortVal & R2_Out(112 downto 97) & R2_Out(80 downto 65) & R2_Out(64 downto 49) & R2_Out(23 downto 21) & R2_Out(7) & R2_Out(6) & R2_Out(5) & R2_Out(4) & R2_Out(3) & R2_Out(2) & R2_Out(1) & R2_Out(0);
R3_In <= Ex_Mem;
R3: my_DFF generic map(n => 75) port map(Clk, Reset, R3_En, R3_In, R3_Out);
----------------------------------------------------------------------------------------------------------------------------------
--4)Memory :-
--------------
--PortVal <= R3_Out(74 downto 59);
--RegData2 <= R3_Out(58 downto 43);
--Pc <= R3_Out(42 downto 27);
--Sp <= R3_Out(26 downto 11);
--Rdst <= R3_Out(10 downto 8);
--MemWrite <= R3_Out(7);
--SpSel <= R3_Out(6);
--CallSel <= R3_Out(5);
--MemPc <= R3_Out(4);
--MemToReg <= R3_Out(3);
--PortWrite <= R3_Out(2);
--PcWrite <= R3_Out(1);
--RegWrite <= R3_Out(0);


--ReadData <= ;


----------------------------------------------------------------------------------------------------------------------------------
--Mem/WB Reg :-
-----------------
--Mem_WB <= PortVal(15 downto 0) & ReadData(15 downto 0) & Rdst(2 downto 0) & MemToReg & PortWrite & PcWrite & RegWrite;
Mem_WB <= R3_Out(74 downto 59) & ReadData & R3_Out(10 downto 8) & R3_Out(3) & R3_Out(2) & R3_Out(1) & R3_Out(0);
R4_In <= Mem_WB;
R4: my_DFF generic map(n => 39) port map(Clk, Reset, R4_En, R4_In, R4_Out);
----------------------------------------------------------------------------------------------------------------------------------
--5)WriteBack :-
-----------------
--PortVal <= R4_Out(38 downto 23);
--ReadData <= R4_Out(22 downto 7);
--Rdst <= R4_Out(6 downto 4);
--MemToReg <= R4_Out(3);
--PortWrite <= R4_Out(2);
--PcWrite <= R4_Out(1);
--RegWrite <= R4_Out(0);



----------------------------------------------------------------------------------------------------------------------------------
end Architecture Pipelined_Processor;