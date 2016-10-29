-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity subleq_tb is

end entity subleq_tb;
-------------------------------------------------------------------------------
architecture behavioral of subleq_tb is

  component subleq is
    generic (
      n : natural := 8);                -- data and address bus width
    port (
      i_clk   : in  std_logic;
      i_rst   : in  std_logic;
      i_rdata : in  std_logic_vector (n-1 downto 0);
      o_wdata : out std_logic_vector (n-1 downto 0);
      o_addr  : out std_logic_vector (n-1 downto 0);
      o_wen   : out std_logic);
  end component subleq;

  component ram is
    generic (
      n         : natural := 8;         -- width of word in bits
      l         : natural := 8;         -- width of address bus in bits
      init_file : string  := "ram.mif");  -- memory intialization file
    port (
      i_addr  : in  std_logic_vector (l-1 downto 0);  -- address input
      i_wdata : in  std_logic_vector (n-1 downto 0);  -- data input
      o_rdata : out std_logic_vector (n-1 downto 0);  -- data output         
      i_wen   : in  std_logic;
      i_clk   : in  std_logic);
  end component ram;


  signal s_addr, s_wdata, s_rdata : std_logic_vector (7 downto 0);
  signal s_clk, s_rst, s_wen : std_logic;
  
begin  -- architecture behavioral

  -----------------------------------------------------------------------------
  -- Memory
  -----------------------------------------------------------------------------
  memory: ram                         
    port map (                                 
      i_addr  => s_addr,
      i_wdata => s_wdata,
      o_rdata => s_rdata,
      i_wen   => s_wen,               
      i_clk   => s_clk);

  -----------------------------------------------------------------------------
  -- Processor
  -----------------------------------------------------------------------------
  processor: subleq
    port map (
      i_clk   => s_clk,
      i_rst   => s_rst,
      i_rdata => s_rdata,
      o_wdata => s_wdata,
      o_addr  => s_addr,
      o_wen   => s_wen);


  clock: process is
  begin  -- process clock
    s_clk <= '0';
    wait for 5 ns;
    s_clk <= '1';
    wait for 5 ns;
  end process clock;

  process is
  begin  -- process
    s_rst <= '1';
    wait for 10 ns;
    s_rst <= '0';

    wait for 400 ns;
    wait;
  end process;
  

end architecture behavioral;
-------------------------------------------------------------------------------
