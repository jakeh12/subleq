-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
------------------------------------------------------------------------------
entity pc_tb is
end entity pc_tb;
-------------------------------------------------------------------------------
architecture behavioral of pc_tb is

  component pc is
  generic (
    n         : natural := 8);           -- width of word in bits
  port (
    i_wdata : in  std_logic_vector (n-1 downto 0);   -- data input
    i_wen   : in  std_logic;                         -- write enable
    o_rdata : out std_logic_vector (n-1 downto 0);  -- data output
    i_rst   : in std_logic;  -- reset input
    i_inc   : in std_logic;
    i_clk   : in std_logic);            -- clock input
  end component pc;

  signal s_wdata, s_rdata : std_logic_vector (7 downto 0);
  signal s_wen, s_rst, s_inc, s_clk : std_logic;
  
begin  -- architecture behavioral

  DUT: pc
    port map (
      i_wdata => s_wdata,
      i_wen   => s_wen,
      o_rdata => s_rdata,
      i_rst   => s_rst,
      i_inc   => s_inc,
      i_clk   => s_clk);

  clock: process is
  begin  -- process clock
    s_clk <= '1';
    wait for 5 ns;
    s_clk <= '0';
    wait for 5 ns;
  end process clock;


  process is
  begin  -- process

    s_rst  <= '1';
    s_wen <= '0';
    s_wdata <= X"00";
    s_inc <= '0';
    wait for 20 ns;
    s_rst  <= '0';
    wait for 40 ns;
    s_inc <= '1';
    wait for 40 ns;
    s_wdata <= X"AF";
    wait for 10 ns;
    s_wen <= '1';
    wait for 10 ns;
    s_wen <= '0';
    wait for 40 ns;
    s_inc <= '0';
    s_rst <= '1';
    wait for 50 ns;
    s_rst <= '0';
    s_inc <= '1';
    s_wen <= '1';
    s_wdata <= X"AA";
    wait for 10 ns;
    s_inc <= '0';
    s_wen <= '1';
    wait;
    
  end process;


end architecture behavioral;
-------------------------------------------------------------------------------
