library ieee;
use ieee.std_logic_1164.all;

entity entityPort is
port( Clk, PortWrite: in std_logic;
RegValueIn: in std_logic_vector(15 downto 0);
RegValueOut: out std_logic_vector(15 downto 0);
inPort: in std_logic_vector(15 downto 0);
outPort: out std_logic_vector(15 downto 0));
end entityPort;

architecture archPort of entityPort is
begin
	process(Clk)
		begin
			if(PortWrite = '1') then
		    	    outPort <= RegValueIn;
			else
  				RegValueOut <= inPort;	
			end if;
		end process;
	
end architecture archPort;
