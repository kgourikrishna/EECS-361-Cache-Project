library ieee;
use ieee.std_logic_1164.all;

entity fullCache is
  port (
	oe	  :	in	std_logic;
	we	  :	in	std_logic;
	index : in	std_logic_vector(4 downto 0);
	tag   : in std_logic_vector(22 downto 0);
	din	  :	in	std_logic_vector(537 downto 0);
	dout  :	out std_logic_vector(537 downto 0)
  );
end fullCache;

architecture structural of fullCache is

component csram is
  generic (
    INDEX_WIDTH : integer;
    BIT_WIDTH : integer
  );
  port (
	cs	  : in	std_logic;
	oe	  :	in	std_logic;
	we	  :	in	std_logic;
	index : in	std_logic_vector(INDEX_WIDTH-1 downto 0);
	din	  :	in	std_logic_vector(BIT_WIDTH-1 downto 0);
	dout  :	out std_logic_vector(BIT_WIDTH-1 downto 0)
  );
end component;


component cmp_n is
  generic (
    n : integer
  );
  port (
    a      : in std_logic_vector(n-1 downto 0);
    b      : in std_logic_vector(n-1 downto 0);

    a_eq_b : out std_logic;
    a_gt_b : out std_logic;
    a_lt_b : out std_logic;

    signed_a_gt_b : out std_logic;
    signed_a_lt_b : out std_logic
  );
end component;


component and_gate is
  port (
    x   : in  std_logic;
    y   : in  std_logic;
    z   : out std_logic
  );
end component;


component or_gate is
  port (
    x   : in  std_logic;
    y   : in  std_logic;
    z   : out std_logic
  );
end component;

component blockMux is
  port (
	sel   : in std_logic_vector(1 downto 0);
	src0   : in std_logic_vector(511 downto 0);
	src1   : in std_logic_vector(511 downto 0);
	z  :	out std_logic_vector(511 downto 0)
  );
end component;

signal doutL, doutR : std_logic_vector(537 downto 0);
signal eqL, eqR   : std_logic;
signal a_gt_b, a_lt_b, signed_a_gt_b, signed_a_lt_b   : std_logic;
signal andResultL, andResultR   : std_logic;
signal selection   : std_logic_vector(1 downto 0);
signal blockOut   : std_logic_vector(511 downto 0);

begin

csramL : csram generic map (5, 538) 
		port map ('1', oe, we, index, din, doutL);
csramR : csram generic map (5, 538) 
		port map ('1', oe, we, index, din, doutR);
compL : cmp_n generic map (23)
      port map(tag, doutL(534 downto 512), eqL, a_gt_b, a_lt_b, signed_a_gt_b, signed_a_lt_b);
compR : cmp_n generic map (23)
       port map(tag, doutR(534 downto 512), eqR, a_gt_b, a_lt_b, signed_a_gt_b, signed_a_lt_b);
andL  : and_gate port map(doutL(537), eqL, andResultL);

andR  : and_gate port map(doutR(537), eqR, andResultR);
selection(0)<=andResultR;
selection(1)<=andResultL;

mux_block : blockMux port map (selection, doutL(511 downto 0), doutR(511 downto 0), blockOut);

end structural;
