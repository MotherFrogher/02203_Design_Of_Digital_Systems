-- -----------------------------------------------------------------------------
--
--  Title      :  FSMD implementation of GCD
--             :
--  Developers :  Jens Sparsø, Rasmus Bo Sørensen and Mathias Møller Bruhn
--           :
--  Purpose    :  This is a FSMD (finite state machine with datapath) 
--             :  implementation the GCD circuit
--             :
--  Revision   :  02203 fall 2019 v.5.0
--
-- -----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gcd is
  port (clk : in std_logic;             -- The clock signal.
    reset : in  std_logic;              -- Reset the module.
    req   : in  std_logic;              -- Input operand / start computation.
    AB    : in  unsigned(15 downto 0);  -- The two operands.
    ack   : out std_logic;              -- Computation is complete.
    C     : out unsigned(15 downto 0)); -- The result.
end gcd;

architecture fsmd of gcd is

  type state_type is (State0, State1, State2, State3, State4, State5, State6, State7, State8); -- Input your own state names

  signal reg_a, next_reg_a, next_reg_b, reg_b, reg_c, next_reg_c : unsigned(15 downto 0);

  signal state, next_state : state_type;
  
--  signal RegA_load, RegB_load, RegC_load : std_logic ;


begin

  -- Combinatoriel logic

  cl : process (req,ab,state,reg_a,reg_b,reg_c,reset)
  begin

    ack <= '0';
    next_state <= state;
    next_reg_a <= x"0000";
    next_reg_b <= x"0000";
    next_reg_c <= x"0000";
--    RegA_load <= '0';
--    RegB_load <= '0';
--    RegC_load <= '0';
    
    case (state) is
        
        when State0 =>
            if req = '1' then
                next_state <= State1;
            end if;
        
        when State1 =>
            next_reg_a <= AB;
            next_state <= State2;
        
        when State2 =>
            ack <= '1';
            next_state <= State3;
        
        when State3 =>
            if req = '1' then         
                next_state <= State4;
            end if;
        
        when State4 =>
            next_reg_b <= AB;
            next_state <= State5;

        when State5 =>
            if reg_a /= reg_b then
                next_state <= State6;
            else
                next_state <= State7;
            end if;

        when State6 =>
            if reg_a > reg_b then
                next_reg_a <= reg_a - reg_b;
            else
                next_reg_b <= reg_b - reg_a;
            end if;
            next_state <= State5;

        when State7 =>
            next_reg_c <= reg_a;
            next_state <= State8;
            
        when State8 =>
            ack <= '1';
            next_state <= State0;

    end case;
  end process cl;

  -- Registers

  seq : process (clk, reset)
  begin

    if reset = '1' then
        state <= State0;
    elsif rising_edge(clk) then
        state <= next_state;
    end if;

  end process seq;
  
  RegA: process(clk, reset)
  begin
    if reset = '1' then
        reg_a <= x"0000";
    elsif rising_edge(clk) and next_reg_a /= x"0000" then
        reg_a <= next_reg_a;
    end if;
  end process RegA;

  RegB: process(clk, reset)
  begin
    if reset = '1' then
        reg_b <= x"0000";
    elsif rising_edge(clk) and next_reg_b /= x"0000" then
        reg_b <= next_reg_b;
    end if;
  end process RegB;

  RegC: process(clk, reset)
  begin
    if reset = '1' then
        reg_c <= x"0000";
    elsif rising_edge(clk) and next_reg_c /= x"0000" then
        reg_c <= next_reg_c;
    end if;
  end process RegC;
  
  C <= reg_c;

end fsmd;
