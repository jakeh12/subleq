-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-------------------------------------------------------------------------------
entity sub is
  generic (
    n : natural := 8);
  port (
    i_a    : in  std_logic_vector (n-1 downto 0);
    i_b    : in  std_logic_vector (n-1 downto 0);
    o_d    : out std_logic_vector (n-1 downto 0));
end entity sub;
-------------------------------------------------------------------------------
architecture dataflow of sub is  
begin

  o_d <= std_logic_vector(unsigned(i_b) - unsigned(i_a));
  
end architecture dataflow;
-------------------------------------------------------------------------------
