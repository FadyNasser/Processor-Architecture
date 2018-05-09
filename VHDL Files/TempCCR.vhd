library ieee;
use ieee.std_logic_1164.all;

entity entityTempCCR is
port( Clk, WriteTempCCR: in std_logic;
CoutCCR, ZeroCCR, NegCCR, OverflowCCR: in std_logic;
Cout, Zero, Neg, Overflow: out std_logic);
end entityTempCCR;

architecture archTempCCR of entityTempCCR is

signal carryFlag, zeroFlag, negativeFlag, overflowFlag: std_logic;

begin
	process(Clk)
		begin		
			if(rising_edge(Clk)) then					
					if(WriteTempCCR = '1') then
  						 carryFlag <= CoutCCR;
			  		  	 zeroFlag <= ZeroCCR;
			 		  	 negativeFlag <= NegCCR;
			  		  	 overflowFlag <= OverflowCCR;
					end if;			
			end if;		
		end process;
		 Cout <= carryFlag;
		 Zero<= zeroFlag;
		 Neg <= negativeFlag;
     		Overflow <= overflowFlag;
end architecture archTempCCR;
