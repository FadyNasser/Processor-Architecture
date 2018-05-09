Library ieee;
Use ieee.std_logic_1164.all;

Entity Reg is
Generic ( n : integer := 16);
port( Clk,Rst, En : in std_logic;
d : in std_logic_vector(n-1 downto 0);
q : out std_logic_vector(n-1 downto 0));
end Reg;

Architecture a_Reg of Reg is
begin
	Process (Clk,Rst)
	begin
		if Rst = '1' then
			q <= (others=>'0');
		elsif En = '1' then
			q <= d;
		end if;
	end process;
end a_Reg;

