library ieee;
use ieee.std_logic_1164.all;

entity entityPort is
port( PortWrite: in std_logic;
RegValueIn: in std_logic_vector(15 downto 0);
RegValueOut: out std_logic_vector(15 downto 0);
inPort: in std_logic_vector(15 downto 0);
outPort: out std_logic_vector(15 downto 0));
end entityPort;

architecture archPort of entityPort is
begin
				
		    	 	   outPort <= RegValueIn when PortWrite = '1';
					RegValueOut <= inPort;	

end architecture archPort;
