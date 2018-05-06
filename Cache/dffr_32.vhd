library ieee;
use ieee.std_logic_1164.all;

entity dffr_32 is
  port (
	clk	   : in  std_logic;
	d	   : in  std_logic_vector(31 downto 0);
	q	   : out std_logic_vector(31 downto 0)
  );
end dffr_32;

architecture behavioral of dffr_32 is
begin
    dffs: for i in 0 to 31 generate
       dff_i: entity work.dffr
          port map(clk=>clk,d=>d(i),q=>q(i));
   end generate;
  
end behavioral;
