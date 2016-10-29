-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-------------------------------------------------------------------------------
entity subleq is
  generic (
    n : natural := 8);                  -- data and address bus width
  port (
    i_clk   : in  std_logic;
    i_rst   : in  std_logic;
    i_rdata : in  std_logic_vector (n-1 downto 0);
    o_wdata : out std_logic_vector (n-1 downto 0);
    o_addr  : out std_logic_vector (n-1 downto 0));
end entity subleq;
-------------------------------------------------------------------------------
architecture structural of subleq is

  component pc is
    generic (
      n : natural := n);                              -- width of word in bits
    port (
      i_wdata : in  std_logic_vector (n-1 downto 0);  -- data input
      i_wen   : in  std_logic;                        -- write enable
      o_rdata : out std_logic_vector (n-1 downto 0);  -- data output
      i_rst   : in  std_logic;                        -- reset input
      i_inc   : in  std_logic;
      i_clk   : in  std_logic);                       -- clock input
  end component pc;

  component reg is
    generic (
      n : natural := n);                              -- width of word in bits
    port (
      i_wdata : in  std_logic_vector (n-1 downto 0);  -- data input
      i_wen   : in  std_logic;                        -- write enable
      o_rdata : out std_logic_vector (n-1 downto 0);  -- data output
      i_rst   : in  std_logic;                        -- reset input
      i_clk   : in  std_logic);                       -- clock input
  end component reg;

  component ram is
    generic (
      n         : natural := n;           -- width of word in bits
      l         : natural := n;           -- width of address bus in bits                                 
      init_file : string  := "ram.mif");  -- memory intialization file
    port (
      i_addr  : in  std_logic_vector (n-1 downto 0);  -- address input
      i_wdata : in  std_logic_vector (n-1 downto 0);  -- data input
      o_rdata : out std_logic_vector (n-1 downto 0);  -- data output
      i_wen   : in  std_logic;
      i_clk   : in  std_logic);
  end component ram;

  component sub is
    generic (
      n : natural := n);
    port (
      i_a : in  std_logic_vector (n-1 downto 0);   -- subtrahend input
      i_b : in  std_logic_vector (n-1 downto 0);   -- minuend input
      o_d : out std_logic_vector (n-1 downto 0));  -- difference output
  end component;

  signal s_reg_a, s_reg_b_addr, s_reg_b, s_reg_c, s_sub_d, s_mem_rdata, s_mem_addr : std_logic_vector (n-1 downto 0);
  signal s_reg_a_wen, s_reg_b_addr_wen, s_reg_b_wen, s_reg_c_wen, s_pc_wen, s_pc_inc, s_mem_wen, s_leq : std_logic;
  signal s_mem_addr_src : std_logic_vector (1 downto 0);

  
begin  -- architecture behavioral


  -----------------------------------------------------------------------------
  -- Registers
  -----------------------------------------------------------------------------
  reg_a: reg
    port map (
      i_wdata => s_mem_rdata,
      i_wen   => s_reg_a_wen,
      o_rdata => s_reg_a,
      i_rst   => i_rst,
      i_clk   => i_clk);

  
  reg_b_addr: reg
    port map (
      i_wdata => s_mem_rdata,
      i_wen   => s_reg_b_addr_wen,
      o_rdata => s_reg_b_addr,
      i_rst   => i_rst,
      i_clk   => i_clk);

  
  reg_b: reg
    port map (
      i_wdata => s_mem_rdata,
      i_wen   => s_reg_b_wen,
      o_rdata => s_reg_b,
      i_rst   => i_rst,
      i_clk   => i_clk);

  
  reg_c: reg
    port map (
      i_wdata => s_mem_rdata,
      i_wen   => s_reg_c_wen,
      o_rdata => s_reg_c,
      i_rst   => i_rst,
      i_clk   => i_clk);


  
  -----------------------------------------------------------------------------
  -- Program Counter
  -----------------------------------------------------------------------------
  program_counter: pc
    port map (
      i_wdata => s_reg_c,
      i_wen   => s_leq,
      o_rdata => s_pc_rdata,
      i_rst   => i_rst,
      i_inc   => s_pc_inc,
      i_clk   => i_clk);


  
  -----------------------------------------------------------------------------
  -- Subtractor
  -----------------------------------------------------------------------------
  subtractor: sub
    port map (
      i_a => s_reg_a,
      i_b => s_reg_b,
      o_d => s_sub_d);

  -- less than or equal to zero branch flag
  s_leq <= '1' when ((unsigned(s_sub_d) = '0') or s_sub_d(n-1) = '1') else '0';




  -----------------------------------------------------------------------------
  -- Memory
  -----------------------------------------------------------------------------
  memory: ram
    port map (
      i_addr  => s_mem_addr,
      i_wdata => s_sub_d,
      o_rdata => s_mem_rdata,
      i_wen   => s_mem_wen,
      i_clk   => i_clk);

  -- s_mem_addr mux
  s_mem_addr <= s_pc when s_mem_addr_src = "00" else
                s_reg_a when s_mem_addr_src = "01" else
                s_reg_b_addr when s_mem_addr_src = "1-";


  -----------------------------------------------------------------------------
  -- Control
  -----------------------------------------------------------------------------
  
end architecture structural;
-------------------------------------------------------------------------------
