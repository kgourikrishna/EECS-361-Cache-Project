library ieee;
use ieee.std_logic_1164.all;

entity cache_control_tb is
end entity cache_control_tb;

architecture behavioral of cache_control_tb is

signal clk_tb : std_logic;
signal current_tb, next_tb : std_logic_vector(3 downto 0);
signal CpuReq_tb,Match_tb,Valid_tb,Dirty_tb,MemReady_tb,CpuReady_tb : std_logic;

component cache_control is
port (
	clk : in std_logic;
	current_state : in std_logic_vector(3 downto 0);
	CpuReq : in std_logic;
	Match : in std_logic;
	Valid : in std_logic;
	Dirty : in std_logic;
	MemReady : in std_logic;
	CpuReady : out std_logic;
	next_state : out std_logic_vector (3 downto 0)
);
end component cache_control;

begin

test_control : cache_control port map (clk_tb,current_tb,CpuReq_tb,Match_tb,Valid_tb,Dirty_tb,MemReady_tb,CpuReady_tb,next_tb);

process
begin
	clk_tb <= '1';
	wait for 1 ns;
	clk_tb <= '0';
	wait for 1 ns;

end process;



testbench : process
begin
	current_tb <= "0100";
	CpuReq_tb <= '1';
	Match_tb <= '1';
	Valid_tb <= '1';
	Dirty_tb <= '1';
	MemReady_tb <= '1';

	wait for 1 ns;



end process;



end architecture behavioral;
