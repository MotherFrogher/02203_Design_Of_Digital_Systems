----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.09.2026 11:14:15
-- Design Name: 
-- Module Name: FSM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM is
    Port(req, clk, N, Z, reset: in std_logic;
        fn: out std_logic_vector(1 downto 0);
        ABorALU, LDA, LDB, ack: out std_logic);
end FSM;

architecture Behavioral of FSM is
type statetype is (state0, state1, state2, state3, state4, state5, state6, state7, state8, state9);
signal state, next_state : statetype;


begin

CL: process(state, req, reset, N, Z)
begin
    --state <= next_state;
    LDA <= '0';
    LDB <= '0';
    ack <= '0';
    fn <= "00";
    
    case state is
        
        when state0 =>
            ack <= '0';
            
            if req = '1' then
                next_state <= state1;
            else
                next_state <= state0;
            end if;
            
        when state1 =>
            ack <= '1';
            ABorALU <= '0';
            LDA <= '1';
            next_state <= state2;
            
        when state2 =>
            ack <= '0';
            next_state <= state3;
        
        when state3 =>
            if req = '1' then
                next_state <= state4;
            else
                next_state <= state0;
            end if;
        
        when state4 =>
            ABorALU <= '0';
            LDB <= '1';
            next_state <= state5;
            
        when state5 =>
            ABorALU <= '1';
            if Z = '1' then
                next_state <= state9;
            elsif Z = '0' then
                next_state <= state6;
            end if;
            
         when state6 =>
            if N = '1' then
                next_state <= state8;
            else
                next_state <= state7;
            end if;
            
         when state7 =>
            LDA <= '1';
            ABorALU <= '1';
            next_state <= state5;
            
         when state8 =>
            LDB <= '1';
            fn <= "01";
            ABorALU <= '1';
            next_state <= state5;
            
         when state9 =>
            fn <= "10";
            ABorALU <= '1';
            Ack <= '1';
            next_state <= state0;
    end case;
end process;


State_process : process(clk, reset)
begin
    if reset = '1' then
        state <= state0;
    elsif rising_edge(clk) then
        state <= next_state;
    end if;
end process;
        

end Behavioral;
