----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/08/2026 10:41:34 AM
-- Design Name: 
-- Module Name: acc_top - Behavioral
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
use IEEE.NUMERIC_STD.ALL;


entity acc_top is
    port(
        Px0,Px1,Px2,Px3,Px4,Px5,Px6,Px7,Px8,Px9,Px10,Px11,Px12,Px13,Px14,Px15,Px16,Px17: in  unsigned (7 downto 0);            
        output1,output2,output3,output4  : out  unsigned ( 7 downto 0)
    );
end acc_top;

architecture Behavioral of acc_top is

    component acc
        port(
        Px0,Px1,Px2,Px3,Px4,Px5,Px6,Px7,Px8    : in  unsigned (7 downto 0);
        output  : out  unsigned ( 7 downto 0)
        );
    end component acc;

begin
    ACC_1 : acc
        port map(
            Px0 => Px0,
            Px1 => Px1,
            Px2 => Px2,
            Px3 => Px6,
            Px4 => Px7,
            Px5 => Px8,
            Px6 => Px12,
            Px7 => Px13,
            Px8 => Px14,
            output => output1
        );
     ACC_2 : acc
        port map(
            Px0 => Px1,
            Px1 => Px2,
            Px2 => Px3,
            Px3 => Px7,
            Px4 => Px8,
            Px5 => Px9,
            Px6 => Px13,
            Px7 => Px14,
            Px8 => Px15,
            output => output2
        );
     ACC_3 : acc
        port map(
            Px0 => Px2,
            Px1 => Px3,
            Px2 => Px4,
            Px3 => Px8,
            Px4 => Px9,
            Px5 => Px10,
            Px6 => Px14,
            Px7 => Px15,
            Px8 => Px16,
            output => output3
        );
     ACC_4 : acc
        port map(
            Px0 => Px3,
            Px1 => Px4,
            Px2 => Px5,
            Px3 => Px9,
            Px4 => Px10,
            Px5 => Px11,
            Px6 => Px15,
            Px7 => Px16,
            Px8 => Px17,
            output => output4
        );
       
end Behavioral;
