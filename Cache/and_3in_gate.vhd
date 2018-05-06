library ieee;
use ieee.std_logic_1164.all;

entity and_3in_gate is

  port (
    x  : in std_logic;
    y  : in std_logic;
    z  : in std_logic;
    o  : out std_logic
  );
end entity and_3in_gate;

architecture structural of and_3in_gate is 
signal xy : std_logic;

component and_gate is
  port (
    x   : in  std_logic;
    y   : in  std_logic;
    z   : out std_logic
  );
end component and_gate;

begin

and1: and_gate port map(x,y,xy);
and2: and_gate port map(xy,z,o);

end architecture structural;

