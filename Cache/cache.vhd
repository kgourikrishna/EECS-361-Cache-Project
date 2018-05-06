library ieee;
use ieee.std_logic_1164.all;

entity cache is
port (
	clk : in std_logic;
	rst : in std_logic;
	en : in std_logic;

	cpuReq : in std_logic;
	cpuWr : in std_logic;
	cpuAddr : in std_logic_vector(31 downto 0);
	cpuDin : in std_logic_vector(31 downto 0);
	cpuDout : out std_logic_vector(31 downto 0);
	cpuReady : out std_logic;

	memReq : out std_logic;
	memWr : out std_logic;
	memAddr : out std_logic_vector(31 downto 0);
	memDout : out std_logic_vector((64*8-1) downto 0);
	memDin : in std_logic_vector((64*8-1) downto 0);
	memReady : in std_logic;

	hit_cnt : out std_logic_vector(31 downto 0);
	miss_cnt : out std_logic_vector(31 downto 0);
	evict_cnt : out std_logic_vector(31 downto 0)
);
end entity cache; 

architecture structural of cache is

component cache_control is
port (
	clk : in std_logic;
	rst : in std_logic;
	en : in std_logic;
	current_state : in std_logic_vector(3 downto 0);
	CpuReq : in std_logic;
	Match : in std_logic;
	Valid : in std_logic;
	Dirty : in std_logic;
	MemReady : in std_logic;
	--CpuReady : out std_logic;
	next_state : out std_logic_vector (3 downto 0)
);
end component cache_control;

component mux_4_in is
port (
sel   : in       std_logic_vector(1 downto 0);
src0  :	in	 std_logic_vector(31 downto 0);
src1  :	in	 std_logic_vector(31 downto 0);
src2  :	in	 std_logic_vector(31 downto 0);
src3  :	in	 std_logic_vector(31 downto 0);
z     : out      std_logic_vector(31 downto 0)
);
end component mux_4_in;

component and_3in_gate is

  port (
    x  : in std_logic;
    y  : in std_logic;
    z  : in std_logic;
    o  : out std_logic
  );
end component and_3in_gate;

component not_gate is
  port (
    x   : in  std_logic;
    z   : out std_logic
  );
end component not_gate;

component mux_16_in is
port (
sel   : in       std_logic_vector(3 downto 0);
src0  :	in	 std_logic_vector(31 downto 0);
src1  :	in	 std_logic_vector(31 downto 0);
src2  :	in	 std_logic_vector(31 downto 0);
src3  :	in	 std_logic_vector(31 downto 0);
src4  :	in	 std_logic_vector(31 downto 0);
src5  :	in	 std_logic_vector(31 downto 0);
src6  :	in	 std_logic_vector(31 downto 0);
src7  :	in	 std_logic_vector(31 downto 0);
src8  :	in	 std_logic_vector(31 downto 0);
src9  :	in	 std_logic_vector(31 downto 0);
src10  :	in	 std_logic_vector(31 downto 0);
src11  :	in	 std_logic_vector(31 downto 0);
src12  :	in	 std_logic_vector(31 downto 0);
src13  :	in	 std_logic_vector(31 downto 0);
src14  :	in	 std_logic_vector(31 downto 0);
src15  :	in	 std_logic_vector(31 downto 0);
z     : out      std_logic_vector(31 downto 0)
);
end component mux_16_in;

component dffr_32_n is
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
end component dffr_32_n;

component dffr_n is
  generic (n : integer);
  port (
	clk	   : in  std_logic;
	d	   : in  std_logic_vector(n-1 downto 0);
	q	   : out std_logic_vector(n-1 downto 0)
  );
end component dffr_n;


component dffr_32 is
  port (
	clk	   : in  std_logic;
    	arst   : in  std_logic;
    	aload  : in  std_logic; --read
    	adata  : in  std_logic_vector(31 downto 0);
	d	   : in  std_logic_vector(31 downto 0);
    	enable : in  std_logic; --write
	q	   : out std_logic_vector(31 downto 0)
  );
end component dffr_32;

component dffr_a is
  port (
	clk	   : in  std_logic;
    arst   : in  std_logic;
    aload  : in  std_logic;
    adata  : in  std_logic;
	d	   : in  std_logic;
    enable : in  std_logic;
	q	   : out std_logic
  );
end component dffr_a;

component fullCache is
  port (
	clk : in std_logic;
	rst : in std_logic;
	en : in std_logic;
	oe	  :	in	std_logic;
	we	  :	in	std_logic;
	wrFromMem   : in std_logic;
	memDin : in std_logic_vector(511 downto 0);
	addr   : in std_logic_vector(31 downto 0);
	din    : in std_logic_vector(31 downto 0);
	dout   : out std_logic_vector(511 downto 0);
	memReq   : out std_logic;
	match   : out std_logic;
	valid   : out std_logic;
	evict_selector : out std_logic;
	dirty   : out std_logic
  );
end component fullCache;

component and_gate is
  port (
    x   : in  std_logic;
    y   : in  std_logic;
    z   : out std_logic
  );
end component and_gate;

component or_gate is
  port (
    x   : in  std_logic;
    y   : in  std_logic;
    z   : out std_logic
  );
end component or_gate;

component dffr is
  port (
	clk	: in  std_logic;
	d	: in  std_logic;
	q	: out std_logic
  );
end component dffr;

component fulladder_32 is
  port (
    cin   : in std_logic;
    x     : in std_logic_vector(31 downto 0);
    y     : in std_logic_vector(31 downto 0);
    cout  : out std_logic;
    z     : out std_logic_vector(31 downto 0)
  );
end component fulladder_32;

component mux_32 is
  port (
	sel   : in  std_logic;
	src0  : in  std_logic_vector(31 downto 0);
	src1  : in  std_logic_vector(31 downto 0);
	z	    : out std_logic_vector(31 downto 0)
  );
end component mux_32;


signal cacheOE,cacheWE,cacheAddr,cacheDin,writeFrmem : std_logic;
signal cacheDout : std_logic_vector (511 downto 0);
signal current_s, next_s : std_logic_vector (3 downto 0);
signal match_s,valid_s,dirty_s : std_logic;
signal CT_wr : std_logic;
signal cpuWr_s : std_logic;
signal cpuDin_s,cpuAddr_s : std_logic_vector(31 downto 0);
signal cpur1,cpur2,CpuReqnot,CpuReady_s : std_logic;
signal miss_add,evict_add,hit_add,hit_subtract : std_logic_vector(31 downto 0);
signal cout : std_logic;
signal miss_cnt_s,hit_cnt_s : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
signal miss_cnt_out,hit_cnt_sub,hit_cnt_add,hit_cnt_out : std_logic_vector (31 downto 0);
signal evict_selector : std_logic;
signal evict_cnt_s : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
signal evict_cnt_out : std_logic_vector (31 downto 0);
signal hit_select : std_logic_vector (1 downto 0);


begin

dffr1 : dffr_32_n generic map (4) port map (clk,rst,rst,"0001",next_s,en,current_s);
dffr2 : dffr_a port map (cpuReq,rst,'0','0',cpuWr,en,cpuWr_s);
dffr3 : dffr_32 port map (cpuReq,rst,'0',"00000000000000000000000000000000",cpuDin,en,cpuDin_s);
dffr4 : dffr_32 port map (cpuReq,rst,'0',"00000000000000000000000000000000",cpuAddr,en,cpuAddr_s);

not1 : not_gate port map (cpuReq, CpuReqnot);

control_machine : cache_control port map (clk,rst,en,current_s,cpuReq,match_s,valid_s,dirty_s,memReady,next_s);

l1_cache : fullCache port map (clk,rst,en,cacheOE,cacheWE,writeFrmem,memDin,cpuAddr_s,cpuDin_s,cacheDout,memReq,match_s,valid_s,evict_selector,dirty_s);

--mux_out : mux_16_in port map (cpuAddr_s(3 downto 0),cacheDout(31 downto 0),cacheDout(63 downto 32), cacheDout (95 downto 64), cacheDout(127 downto 96),cacheDout(159 downto 128),cacheDout(191 downto 160),cacheDout(223 downto 192),cacheDout(255 downto 224),cacheDout(287 downto 256),cacheDout(319 downto 288),cacheDout(351 downto 320),cacheDout(383 downto 352),cacheDout(415 downto 384),cacheDout(447 downto 416),cacheDout(479 downto 448),cacheDout(511 downto 480),cpuDout);
cpuDout <= cacheDout(31 downto 0);
cacheOE <= current_s(1);

and1 : and_gate port map (current_s(1),cpuWr_s,CT_wr);
or1 : or_gate port map (CT_wr,current_s(3),cacheWE);

writeFrmem <= current_s(3);

memWr <= current_s(2);

memDout <= cacheDout;

memAddr <= cpuAddr;

--CpuReady

--and10 : and_3in_gate port map (current_s(1),match_s,valid_s,cpur1);
--and11 : and_gate port map (current_s(0),CpuReqnot,cpur2);
--or7 : or_gate port map (cpur2,cpur1,CpuReady_s);

--andtest : and_gate port map (current_s(0),next_s(0),CpuReady_s);

CpuReady_s <= next_s(0);



dff5 : dffr_a port map (clk,rst,'0','0',CpuReady_s,en,cpuReady);

mux_miss : mux_32 port map (next_s(3),"00000000000000000000000000000000","00000000000000000000000000000001",miss_add);
miss_adder : fulladder_32 port map ('0',miss_cnt_s,miss_add,cout,miss_cnt_out);

mux_evict : mux_32 port map (evict_selector,"00000000000000000000000000000000","00000000000000000000000000000001",evict_add);
evict_adder : fulladder_32 port map ('0',evict_cnt_s,evict_add,cout,evict_cnt_out);
dff7: dffr_32 port map (clk,rst,'0',"00000000000000000000000000000000",evict_cnt_out,en,evict_cnt_s);


dff6: dffr_32 port map (clk,rst,'0',"00000000000000000000000000000000",miss_cnt_out,en,miss_cnt_s);


hit_select(0) <= next_s(0);
hit_select(1) <= current_s(3);



hit_mux : mux_4_in port map (hit_select,"00000000000000000000000000000000","00000000000000000000000000000001","11111111111111111111111111111111","00000000000000000000000000000000",hit_add);

hit_adder : fulladder_32 port map ('0',hit_cnt_s,hit_add,cout,hit_cnt_out);

dff8 : dffr_32 port map (clk,rst,'0',"00000000000000000000000000000000",hit_cnt_out,en,hit_cnt_s);

hit_cnt <= hit_cnt_s;
evict_cnt <= evict_cnt_s;
miss_cnt <= miss_cnt_s;
end architecture structural;