library ieee;
use ieee.std_logic_1164.all;

entity mux_64b_in is
port (
sel   : in       std_logic_vector(3 downto 0);
src0  :	in	 std_logic_vector(537 downto 0);
src1  :	in	 std_logic_vector(537 downto 0);
src2  :	in	 std_logic_vector(537 downto 0);
src3  :	in	 std_logic_vector(537 downto 0);
src4  :	in	 std_logic_vector(537 downto 0);
src5  :	in	 std_logic_vector(537 downto 0);
src6  :	in	 std_logic_vector(537 downto 0);
src7  :	in	 std_logic_vector(537 downto 0);
src8  :	in	 std_logic_vector(537 downto 0);
src9  :	in	 std_logic_vector(537 downto 0);
src10  :	in	 std_logic_vector(537 downto 0);
src11  :	in	 std_logic_vector(537 downto 0);
src12  :	in	 std_logic_vector(537 downto 0);
src13  :	in	 std_logic_vector(537 downto 0);
src14  :	in	 std_logic_vector(537 downto 0);
src15  :	in	 std_logic_vector(537 downto 0);
z     : out      std_logic_vector(537 downto 0)
);
end mux_64b_in;

architecture structural of mux_64b_in is

signal mux0: std_logic_vector(537 downto 0);
signal mux1: std_logic_vector(537 downto 0);
signal mux2: std_logic_vector(537 downto 0);
signal mux3: std_logic_vector(537 downto 0);
signal mux4: std_logic_vector(537 downto 0);
signal mux5: std_logic_vector(537 downto 0);
--signal mux6: std_logic_vector(31 downto 0);

component mux_cachesize_4 is
port (
sel   : in       std_logic_vector(1 downto 0);
src0  :	in	 std_logic_vector(537 downto 0);
src1  :	in	 std_logic_vector(537 downto 0);
src2  :	in	 std_logic_vector(537 downto 0);
src3  :	in	 std_logic_vector(537 downto 0);
z     : out      std_logic_vector(537 downto 0)
);
end component mux_cachesize_4;

begin

mux_1 : mux_cachesize_4 port map (sel(1 downto 0),src0,src1,src2,src3,mux1);
mux_2 : mux_cachesize_4 port map (sel(1 downto 0),src4,src5,src6,src7,mux2);
mux_3 : mux_cachesize_4 port map (sel(1 downto 0),src8,src9,src10,src11,mux3);
mux_4 : mux_cachesize_4 port map (sel(1 downto 0),src12,src13,src14,src15,mux4);
mux_5 : mux_cachesize_4 port map (sel(3 downto 2),mux1,mux2,mux3,mux4,z);

end architecture structural;
