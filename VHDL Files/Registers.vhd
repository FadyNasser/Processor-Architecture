Library ieee;
Use ieee.std_logic_1164.all;

entity Registers is
port( Clk, Rst, RegWrite : in std_logic;
Write_Reg, Reg_1, Reg_2 : in std_logic_vector (2 downto 0);
Data_1, Data_2 : out std_logic_vector (15 downto 0);
Write_Data : in std_logic_vector(15 downto 0));
end Registers;

Architecture Registers_Arch of Registers is
	Component Reg is
	Generic ( n : integer := 16);
	port( Clk,Rst, En : in std_logic;
	d : in std_logic_vector(n-1 downto 0);
	q : out std_logic_vector(n-1 downto 0));
end component;
	signal R1_En, R2_En, R3_En ,R4_En, R5_En, R6_En, R7_En, R8_En : std_logic;
	signal R1_Out, R2_Out, R3_Out, R4_Out, R5_Out, R6_Out, R7_Out, R8_Out : std_logic_vector(15 downto 0);
begin
	
	R1: Reg generic map(n => 16) port map(Clk, Rst, R1_En, Write_Data, R1_Out);
	R2: Reg generic map(n => 16) port map(Clk, Rst, R2_En, Write_Data, R2_Out);
	R3: Reg generic map(n => 16) port map(Clk, Rst, R3_En, Write_Data, R3_Out);
	R4: Reg generic map(n => 16) port map(Clk, Rst, R4_En, Write_Data, R4_Out);
	R5: Reg generic map(n => 16) port map(Clk, Rst, R5_En, Write_Data, R5_Out);
	R6: Reg generic map(n => 16) port map(Clk, Rst, R6_En, Write_Data, R6_Out);
	R7: Reg generic map(n => 16) port map(Clk, Rst, R7_En, Write_Data, R7_Out);
	R8: Reg generic map(n => 16) port map(Clk, Rst, R8_En, Write_Data, R8_Out);

	R1_En <= '1' when RegWrite = '1' and Write_Reg = "000" else '0';
	R2_En <= '1' when RegWrite = '1' and Write_Reg = "001" else '0';
	R3_En <= '1' when RegWrite = '1' and Write_Reg = "010" else '0';
	R4_En <= '1' when RegWrite = '1' and Write_Reg = "011" else '0';
	R5_En <= '1' when RegWrite = '1' and Write_Reg = "100" else '0';
	R6_En <= '1' when RegWrite = '1' and Write_Reg = "101" else '0';
	R7_En <= '1' when RegWrite = '1' and Write_Reg = "110" else '0';
	R8_En <= '1' when RegWrite = '1' and Write_Reg = "111" else '0';
	
	with Reg_1 select
		Data_1 <=    R1_Out when "000",
			     R2_Out when "001",
			     R3_Out when "010",
		             R4_Out when "011",
			     R5_Out when "100",
			     R6_Out when "101",
			     R7_Out when "110",
			     R8_Out when others;

	with Reg_2 select
		Data_2 <=    R1_Out when "000",
			     R2_Out when "001",
			     R3_Out when "010",
		             R4_Out when "011",
			     R5_Out when "100",
			     R6_Out when "101",
			     R7_Out when "110",
			     R8_Out when others;
end Registers_Arch;
