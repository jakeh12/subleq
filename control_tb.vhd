-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity control_tb is

end entity control_tb;
-------------------------------------------------------------------------------
architecture control of control_tb is

  component control is
    port (
      i_clk            : in  std_logic;   -- clock input
      i_rst            : in  std_logic;   -- reset input
      o_pc_inc         : out std_logic;
      o_reg_a_wen      : out std_logic;
      o_reg_b_addr_wen : out std_logic;
      o_reg_b_wen      : out std_logic;
      o_reg_c_wen      : out std_logic;
      o_mem_wen        : out std_logic;
      o_mem_addr_src   : out std_logic_vector (1 downto 0));
  end component control;

  signal s_clk, s_rst : std_logic;
  signal s_pc_inc, s_reg_a_wen, s_reg_b_addr_wen, s_reg_b_wen, s_reg_c_wen, s_mem_wen : std_logic;
  signal s_mem_addr_src : std_logic_vector (1 downto 0);
  
begin  -- architecture control

  clock: process is
  begin  -- process clock
    s_clk <= '1';
    wait for 5 ns;
    s_clk <= '0';
    wait for 5 ns;
  end process clock;


  DUT: control
    port map (
      i_clk            => s_clk,
      i_rst            => s_rst,
      o_pc_inc         => s_pc_inc,
      o_reg_a_wen      => s_reg_a_wen,
      o_reg_b_addr_wen => s_reg_b_addr_wen,
      o_reg_b_wen      => s_reg_b_wen,
      o_reg_c_wen      => s_reg_c_wen,
      o_mem_wen        => s_mem_wen,
      o_mem_addr_src   => s_mem_addr_src);

  process is
  begin  -- process
    s_rst <= '0';
    wait for 100 ns;
    s_rst <= '1';
    wait for 20 ns;
    s_rst <= '0';
    wait for 40 ns;
    wait;
  end process;


end architecture control;
-------------------------------------------------------------------------------
