-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity sub_tb is
  
end entity sub_tb;
-------------------------------------------------------------------------------
architecture behavioral of sub_tb is

  component sub is
    generic (
      n : natural := 8);
    port (
    i_a    : in  std_logic_vector (n-1 downto 0);
    i_b    : in  std_logic_vector (n-1 downto 0);
    o_d    : out std_logic_vector (n-1 downto 0));
  end component;

  signal s_a, s_b, s_d : std_logic_vector (7 downto 0);
  
begin  -- architecture subtractor_tb


  DUT: sub
    port map (
      i_a    => s_a,
      i_b    => s_b,
      o_d    => s_d);

  process is
  begin  -- process
    s_b <= X"02";
    s_a <= X"FF";
    wait for 10 ns;

    s_b <= X"FF";
    s_a <= X"FF";
    wait for 10 ns;

    s_b <= X"0A";
    s_a <= X"02";
    wait for 10 ns;

    s_b <= X"0A";
    s_a <= X"FE";
    wait for 10 ns;


    wait;
  end process;

end architecture behavioral;
-------------------------------------------------------------------------------
