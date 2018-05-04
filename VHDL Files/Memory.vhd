
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

entity Memory is
generic(n:integer:=10; m:integer:=16);
port( Clk, MemWrite : in std_logic;
Write_Data : in std_logic_vector (m-1 downto 0);
Read_Data : out std_logic_vector (m-1 downto 0);
Address : in std_logic_vector(n-1 downto 0));
end Memory;

Architecture Memory_Arch of Memory is

type ram_type is array(0 to 2**n-1) of std_logic_vector(m-1 downto 0);
signal ram : ram_type;

begin
process(Clk) is
begin
	if rising_edge(Clk) and MemWrite='1' then
		ram(to_integer(unsigned(Address))) <= Write_Data;
	end if;
end process;
Read_Data <= ram(to_integer(unsigned(Address)));

end Memory_Arch;
