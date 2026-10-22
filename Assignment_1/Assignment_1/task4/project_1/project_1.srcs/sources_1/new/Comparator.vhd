----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.09.2026 12:43:58
-- Design Name: 
-- Module Name: Comparator - Structural
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
use IEEE.numeric_std.ALL;

entity Comparator is
    Port (A, B: in std_logic;
        ALB, AGB, EQ: out std_logic); -- ALB: A < B, AGB: A > B, EQ: A = B
end Comparator;

architecture Structural of Comparator is

begin

ALB <= not(A) and B;

EQ <= not((not(A) and B) or (A and not(B)));

AGB <= A and not(B);


end Structural;
