library ieee;
use ieee.std_logic_1164.all;

entity cache_control is
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
end entity cache_control;

architecture structural of cache_control is

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

component or_gate is
  port (
    x   : in  std_logic;
    y   : in  std_logic;
    z   : out std_logic
  );
end component or_gate;

component not_gate is
  port (
    x   : in  std_logic;
    z   : out std_logic
  );
end component not_gate;

component and_gate is
  port (
    x   : in  std_logic;
    y   : in  std_logic;
    z   : out std_logic
  );
end component and_gate;


component and_3in_gate is

  port (
    x  : in std_logic;
    y  : in std_logic;
    z  : in std_logic;
    o  : out std_logic
  );
end component and_3in_gate;

component and_4in_gate is

  port (
    x  : in std_logic;
    y  : in std_logic;
    z  : in std_logic;
    a  : in std_logic;
    o  : out std_logic
  );
end component and_4in_gate;

component nand_gate is
  port (
    x   : in  std_logic;
    y   : in  std_logic;
    z   : out std_logic
  );
end component nand_gate;

signal CpuReqnot,MemReadynot,Matchnot,Validnot, Dirtynot : std_logic;

signal idle_cpureq,CTmv,A_Memr,or_1,idle_din : std_logic;
signal wb_memr,Ctmvd,wb_din : std_logic;
signal CT_din : std_logic;
signal A_memrnot,mdnot,mdvnot,Ctmdvnot,wb_mem, A_or,A_din : std_logic;

signal cpur1,cpur2,cpur3,cpur4 : std_logic;

signal CpuReq_high,CpuReady_s : std_logic;
signal cnot1,cnot2,cnot3,cnot4,cnot : std_logic;
signal idle_int : std_logic;


begin



--Idle FlipFlop

not1 : not_gate port map (CpuReq,CpuReqnot);
notc1 : not_gate port map (current_state(0),cnot1);
notc2 : not_gate port map (current_state(1),cnot2);
notc3 : not_gate port map (current_state(2),cnot3);
notc4 : not_gate port map (current_state(3),cnot4);
and1: and_gate port map (current_state(0),CpuReqnot,idle_cpureq);
and2: and_3in_gate port map (current_state(1),Match,Valid,CTmv);
andstart : and_4in_gate port map (cnot1,cnot2,cnot3,cnot4,cnot);
or1 : or_gate port map (idle_cpureq,Ctmv,idle_int);
orstart : or_gate port map (idle_int,cnot,next_state(0));
--dff1 : dffr_a port map (clk,rst,'0','0',idle_din,en,next_state(0));

--Compare Tag FlipFlop

and4: and_gate port map (current_state(0),CpuReq,CpuReq_high);
and3: and_gate port map (current_state(3),MemReady,A_Memr);
or2 : or_gate port map (A_Memr,CpuReq_high,next_state(1));
--dff2: dffr_a port map (clk,rst,'0','0',CT_din,en,next_state(1));

--WB FlipFlop

not2 : not_gate port map (MemReady, MemReadynot);
not3 : not_gate port map (Match, Matchnot);
and5 : and_gate port map (current_state(2),MemReadynot,wb_memr);
and6 : and_4in_gate port map (current_state(1),Matchnot,Dirty,Valid,Ctmvd);
or3 : or_gate port map (wb_memr,Ctmvd,next_state(2));
--dff3 : dffr_a port map (clk,rst,'0','0',wb_din,en,next_state(2));

--Allocate FlipFlop

not4 : not_gate port map (Valid,Validnot);
notDirty : not_gate port map (Dirty, Dirtynot);
and7 : and_gate port map (current_state(3),MemReadynot, A_memrnot);
and13 : and_gate port map (Matchnot,Dirtynot,mdnot);
or4 : or_gate port map (Validnot,mdnot,mdvnot);
and8 : and_gate port map (current_state(1),mdvnot,Ctmdvnot);
or5 : or_gate port map (Ctmdvnot,A_memrnot,A_or);
and9 : and_gate port map (current_state(2),MemReady,wb_mem);
or6 : or_gate port map (A_or,wb_mem,next_state(3));
--dff4 : dffr_a port map (clk,rst,'0','0',A_din,en,next_state(3));






end architecture structural;
