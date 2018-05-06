library ieee;
use ieee.std_logic_1164.all;

entity csram_test is
end csram_test;

architecture behavioral of csram_test is
signal cs	: std_logic;
signal oe	: std_logic;
signal we	: std_logic;
signal index : std_logic_vector(4 downto 0);
signal din : std_logic_vector(537 downto 0);
signal dout : std_logic_vector(537 downto 0);


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
begin
  csram0: csram generic map (5, 538)
           port map (cs, oe, we, index, din, dout);
  testbench : process
  begin
	cs <= '1';
	oe <= '0';
   we <= '1';
   index <= "00000";
   din <= (0     => '1',
           4     => '1',
           63    => '1',
           511   => '1',
           others => '0');
 
	wait for 100 ns;
	oe <= '1';
	wait for 100 ns;
	oe<='0';
	
	we <= '1';
	index <= "00000";
	din <= (0   => '1',
	        1   => '1',
	        2   => '1',
	        3   => '1',
           4   => '1',
           63  => '1',
           511 => '1',
           others => '0');
   wait for 100 ns;
           
   oe <='1';
	
	wait for 100 ns;
	oe <= '0';
	we<='0';
	din <= (0   => '0',
	           1   => '0',
	           2   => '0',
	           3   => '1',
              4   => '1',
              63  => '0',
              511 => '0',
              others => '0');
	wait for 100 ns;
	oe<='1';
	
	wait;
  end process;
end behavioral;
