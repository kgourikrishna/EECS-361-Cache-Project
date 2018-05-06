library ieee;
use ieee.std_logic_1164.all;

entity blockMux is
  port (
	sel   : in std_logic_vector(1 downto 0);
	src0   : in std_logic_vector(537 downto 0);
	src1   : in std_logic_vector(537 downto 0);
	src2   : in std_logic_vector(537 downto 0);
	z  :	out std_logic_vector(537 downto 0)
  );
end entity blockMux;

architecture structural of blockMux is

signal mux0: std_logic_vector(537 downto 0);
signal mux1: std_logic_vector(537 downto 0);
signal mux2: std_logic_vector(537 downto 0);
signal undef : std_logic_vector(537 downto 0);

component mux_n is
  generic (
	n	: integer
  );
  port (
	sel	  : in	std_logic;
	src0  :	in	std_logic_vector(n-1 downto 0);
	src1  :	in	std_logic_vector(n-1 downto 0);
	z	  : out std_logic_vector(n-1 downto 0)
  );
end component;

begin

mux_1 : mux_n generic map(538)
            port map (sel(0), src0=>src2, src1=>src1, z=>mux0);
mux_2 : mux_n generic map(538)
            port map (sel(0), src0=>src0, src1=>src2, z=>mux1);
mux_3: mux_n generic map(538)
            port map(sel(1), src0=>mux0, src1=>mux1, z=>mux2);
z <= mux2;
end structural;
