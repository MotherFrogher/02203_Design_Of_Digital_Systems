----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.09.2026 12:54:22
-- Design Name: 
-- Module Name: Comparator_nbit - Behavioral
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
use ieee.numeric_std.all;

entity Comparator_nbit is
    generic(N: natural := 15);
    Port (A, B: in unsigned(N downto 0);
         ALB, AGB, EQ: out std_logic);
end Comparator_nbit;

architecture Behavioral of Comparator_nbit is

component Comparator is
    Port (A, B: in std_ulogic;
        ALB, AGB, EQ: out std_ulogic); -- ALB: A < B, AGB: A > B, EQ: A = B
end component Comparator;

signal ALB_bit, EQ_bit, AGB_bit : unsigned(N downto 0);
signal ALB_buf, EQ_buf, AGB_buf: unsigned(N downto 0);

begin

U0: for i in 0 to 15 generate
        U1: Comparator port map(
            A => A(i),
            B => B(i),
            ALB => ALB_bit(i),
            AGB => AGB_bit(i),
            EQ => EQ_bit(i));
            
        ALB_buf(i) <= ALB_buf(i+1) or (EQ_buf(i+1) and ALB_bit(i));
        AGB_buf(i) <= AGB_buf(i+1) or (EQ_buf(i+1) and AGB_bit(i));
        EQ_buf(i) <= EQ_buf(i+1) and EQ_bit(i);
    end generate;
    
    ALB <= ALB_bit(0);
    AGB <= AGB_bit(0);
    EQ <= EQ_bit(0);

end Behavioral;
