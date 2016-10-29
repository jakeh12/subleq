-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-------------------------------------------------------------------------------
entity rom_tb is
end entity rom_tb;
-------------------------------------------------------------------------------
architecture behavioral of rom_tb is

  component rom is
    generic (
      n         : natural := 8;         -- width of word in bits
      l         : natural := 8;         -- width of address bus in bits
      init_file : string  := "rom.mif");  -- memory intialization file
    port (
      i_addr  : in  std_logic_vector (n-1 downto 0);  -- address input
      o_rdata : out std_logic_vector (n-1 downto 0);  -- data output
      i_clk   : in  std_logic);         -- clock input
  end component rom;

  signal s_addr  : std_logic_vector (7 downto 0);
  signal s_rdata : std_logic_vector (7 downto 0);
  signal s_clk   : std_logic;
  
begin  -- architecture behavioral

  clock : process is
  begin
    s_clk <= '1';
    wait for 5 ns;
    s_clk <= '0';
    wait for 5 ns;
  end process clock;

  DUT : rom
    port map (
      i_addr  => s_addr,
      o_rdata => s_rdata,
      i_clk   => s_clk);

  process is
  begin  -- process
    
    s_addr <= "00000000";
    wait for 10 ns;

    for i in 0 to 255 loop
      s_addr <= std_logic_vector(to_unsigned(i, 8));
      wait for 10 ns;
      assert s_rdata = std_logic_vector(to_unsigned(255-i, 8))
        report "rom test failed, unexpected value at address "
        & integer'image(i)
        severity error;
    end loop;
    wait;
  end process;
  
end architecture behavioral;
-------------------------------------------------------------------------------
