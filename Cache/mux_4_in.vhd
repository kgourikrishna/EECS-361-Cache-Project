library ieee;
use ieee.std_logic_1164.all;

entity mux_4_in is
port (
sel   : in       std_logic_vector(1 downto 0);
src0  :	in	 std_logic_vector(31 downto 0);
src1  :	in	 std_logic_vector(31 downto 0);
src2  :	in	 std_logic_vector(31 downto 0);
src3  :	in	 std_logic_vector(31 downto 0);
z     : out      std_logic_vector(31 downto 0)
);
end mux_4_in;

architecture behavioral of mux_4_in is

signal mux0: std_logic_vector(31 downto 0);
signal mux1: std_logic_vector(31 downto 0);
signal mux2: std_logic_vector(31 downto 0);
signal mux3: std_logic_vector(31 downto 0);

component mux_32 is
  port (
	sel   : in  std_logic;
	src0  : in  std_logic_vector(31 downto 0);
	src1  : in  std_logic_vector(31 downto 0);
	z	    : out std_logic_vector(31 downto 0)
  );
end component mux_32;

begin

mux_1: mux_32  port map ( sel(0), src0 => src0, src1 => src1, z => mux0);
mux_2: mux_32  port map ( sel(0), src0 => src2, src1 => src3, z => mux1);
mux_3: mux_32  port map ( sel(1), src0 => mux0, src1 => mux1, z => z);


end architecture behavioral;
