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
      l         : natural := 8;       -- width of address bus in bits
      init_file : string  := "rom.mif");  -- memory intialization file
    port (
      i_raddr : in  std_logic_vector (n-1 downto 0);   -- address input
      o_rdata : out std_logic_vector (n-1 downto 0));  -- data output
  end component rom;

  signal s_raddr : std_logic_vector (7 downto 0);
  signal s_rdata : std_logic_vector (7 downto 0);
  
begin  -- architecture behavioral

  DUT: rom
    port map (
      i_raddr => s_raddr,
      o_rdata => s_rdata);

  process is
  begin  -- process

    for i in 0 to 255 loop
      s_raddr <= std_logic_vector(to_unsigned(i, 8));
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
