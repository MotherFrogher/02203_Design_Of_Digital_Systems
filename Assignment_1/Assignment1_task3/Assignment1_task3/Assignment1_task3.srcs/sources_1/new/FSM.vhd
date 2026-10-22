library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gcd_fsm is
    port (
        clk          : in  std_logic;
        reset        : in  std_logic;
        req          : in  std_logic;
        ack          : out std_logic;
        a_equal_b    : in  std_logic;
        a_greater_b  : in  std_logic;
        load_a       : out std_logic;
        load_b       : out std_logic;
        sub_a        : out std_logic;
        sub_b        : out std_logic;
        reg_c_enable : out std_logic
    );
end entity gcd_fsm;

architecture behavioral of gcd_fsm is

    type state_type is (
        State0, 
        State1, 
        State2, 
        State3, 
        State4, 
        State5, 
        State6, 
        State7, 
        State8, 
        State9, 
        State10 
    );
    
    signal current_state, next_state : state_type;

begin

    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= State0;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    process(current_state, req, a_equal_b, a_greater_b)
    begin
        
        ack          <= '0';
        load_a       <= '0';
        load_b       <= '0';
        sub_a        <= '0';
        sub_b        <= '0';
        reg_c_enable <= '0';
        next_state   <= current_state;

        case current_state is

            when State0 =>
                if req = '1' then
                    next_state <= State1;
                end if;

            when State1 =>
                load_a     <= '1';
                next_state <= State2;

            when State2 =>
                ack <= '1';
                if req = '0' then
                    next_state <= State3;
                end if;

            when State3 =>
                if req = '1' then
                    next_state <= State4;
                end if;

            when State4 =>
                load_b     <= '1'; 
                next_state <= State5;

            when State5 =>
                ack <= '1';
                if req = '0' then 
                    next_state <= State6;
                end if;

            when State6 =>
                
                if a_equal_b = '1' then
                    next_state <= State9;
                elsif a_greater_b = '1' then
                    next_state <= State8; 
                else
                    next_state <= State7;
                end if;

            when State7 =>
                sub_b      <= '1'; 
                next_state <= State6; 

            when State8 =>
                sub_a      <= '1'; 
                next_state <= State6; 

            when State9 =>
                reg_c_enable <= '1'; 
                next_state   <= State10;

            when State10 =>
                ack        <= '1'; 
                next_state <= State0;

            when others =>
                next_state <= State0;

        end case;
    end process;

end architecture behavioral;