
Library ieee;
Use ieee.std_logic_1164.all;

Entity my_DFF is
Generic ( n : integer := 16);
port( Clk,Rst, En : in std_logic;
d : in std_logic_vector(n-1 downto 0);
q : out std_logic_vector(n-1 downto 0));
end my_DFF;

Architecture a_my_DFF of my_DFF is
begin
	Process (Clk,Rst)
	begin
		if Rst = '1' then
			q <= (others=>'0');
		elsif rising_edge(Clk) and En = '1' then
			q <= d;
		end if;
	end process;
end a_my_DFF;
