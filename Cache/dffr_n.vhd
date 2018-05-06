library ieee;
use ieee.std_logic_1164.all;

entity dffr_32_n is
  generic (n : integer);
  port (
	clk	   : in  std_logic;
    arst   : in  std_logic;
    aload  : in  std_logic; --read
    adata  : in  std_logic_vector(n-1 downto 0);
	d	   : in  std_logic_vector(n-1 downto 0);
    enable : in  std_logic; --write
	q	   : out std_logic_vector(n-1 downto 0)
  );
end dffr_32_n;

architecture behavioral of dffr_32_n is
begin
    dffs: for i in 0 to n-1 generate
       dff_i: entity work.dffr_a
          port map(clk=>clk, arst=>arst, aload=>aload, adata=>adata(i), d=>d(i), enable=>enable, q=>q(i));
   end generate;
  
end behavioral;
