library ieee;
use ieee.std_logic_1164.all;

entity mux_2to1 is
    port (
      selector : in std_logic;
      a: in std_logic_vector(3 downto 0); 
      b: in std_logic_vector(3 downto 0);
      y: out std_logic_vector(3 downto 0)
      );
  end entity mux_2to1;
  
  architecture mux of mux_2to1 is
  begin
    with selector select
      y <=
      a when '0',
      b when '1',
      "0000" when others;
  end mux;