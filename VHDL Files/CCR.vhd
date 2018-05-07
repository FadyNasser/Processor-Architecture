library ieee;
use ieee.std_logic_1164.all;

entity entityCCR is
port( Clk, RST, WriteCCR, SETC, CLRC, CoutAlu, ZeroAlu, NegAlu, OverflowAlu: in std_logic;
CoutTempCCR, ZeroTempCCR, NegTempCCR, OvervlowTempCCR: in std_logic;
Cout, Zero, Neg, Overflow: out std_logic);
end entityCCR;

architecture archCCR of entityCCR is

signal carryFlag, zeroFlag, negativeFlag, overflowFlag: std_logic;

begin
	process(Clk)
		begin
			if(RST = '1')
				then
		    	    carryFlag <= '0';
			    zeroFlag <= '0';
			    negativeFlag <= '0';
			    overflowFlag <= '0';
				
			
			elsif(WriteCCR = '1')
				then
					if(SETC = '1') then
						carryFlag <= '1';
					elsif(CLRC = '1') then
						carryFlag <= '0';
					else
  					 carryFlag <= CoutTempCCR;
			  		  zeroFlag <= ZeroTempCCR;
			 		   negativeFlag <= NegTempCCR;
			  		  overflowFlag <= OvervlowTempCCR;



					end if;
			
			else
			   carryFlag <= CoutAlu;
			    zeroFlag <= ZeroAlu;
			    negativeFlag <= NegAlu;
			   overflowFlag <= OverflowAlu;	
			end if;
		 Cout <= carryFlag;
		 Zero<= zeroFlag;
		 Neg <= negativeFlag;
     		Overflow <= overflowFlag;
		end process;
	
end architecture archCCR;

