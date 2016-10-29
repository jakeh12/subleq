-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity control is
  
  port (
    i_clk            : in  std_logic;   -- clock input
    i_rst            : in  std_logic;   -- reset input
    o_pc_inc         : out std_logic;
    o_reg_a_wen      : out std_logic;
    o_reg_b_addr_wen : out std_logic;
    o_reg_b_wen      : out std_logic;
    o_reg_c_wen      : out std_logic;
    o_mem_wen        : out std_logic;
    o_pc_branch      : out std_logic;
    o_mem_addr_src   : out std_logic_vector (1 downto 0));

end entity control;
-------------------------------------------------------------------------------
architecture behavioral of control is

  type state is (F_ADDR_A, F_VAL_A, F_ADDR_B, F_VAL_B, F_ADDR_C_EXEC, WB_UPD_PC);
  signal current_state, next_state : state;
    
begin  -- architecture behavioral

  
  state_register : process (i_rst, i_clk) is
  begin  -- process state_register
    if i_rst = '1' then
      current_state <= F_ADDR_A;
    elsif rising_edge(i_clk) then
      current_state <= next_state;
    end if;
  end process state_register;


  next_state_logic : process (current_state) is
  begin  -- process next_state_logic
    case current_state is
      when F_ADDR_A      => next_state <= F_VAL_A;
      when F_VAL_A       => next_state <= F_ADDR_B;
      when F_ADDR_B      => next_state <= F_VAL_B;
      when F_VAL_B       => next_state <= F_ADDR_C_EXEC;
      when F_ADDR_C_EXEC => next_state <= WB_UPD_PC;
      when WB_UPD_PC     => next_state <= F_ADDR_A;
      when others        => next_state <= F_ADDR_A;  -- should never happen
    end case;
  end process next_state_logic;


  output_logic : process (current_state) is
  begin  -- process

    -- set all outputs to zero and conditionally assert only the appropriate
    o_pc_inc         <= '0';
    o_reg_a_wen      <= '0';
    o_reg_b_addr_wen <= '0';
    o_reg_b_wen      <= '0';
    o_reg_c_wen      <= '0';
    o_mem_addr_src   <= "00";
    o_mem_wen        <= '0';
    o_pc_branch      <= '0';

    case current_state is
      
      when F_ADDR_A => o_reg_a_wen <= '1';

      when F_VAL_A => o_mem_addr_src <= "01";
                      o_reg_a_wen <= '1';
                      o_pc_inc    <= '1';
                      
      when F_ADDR_B => o_reg_b_addr_wen <= '1';

      when F_VAL_B => o_mem_addr_src <= "1-";
                      o_reg_b_wen <= '1';
                      o_pc_inc    <= '1';

      when F_ADDR_C_EXEC => o_reg_c_wen <= '1';

      when WB_UPD_PC => o_mem_addr_src <= "1-";
                        o_mem_wen <= '1';
                        o_pc_inc  <= '1';
                        o_pc_branch <= '1';
                        
      when others => null;              -- should never happen
    end case;

  end process;


end architecture behavioral;
-------------------------------------------------------------------------------
