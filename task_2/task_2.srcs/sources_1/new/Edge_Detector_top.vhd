----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.11.2026 09:34:49
-- Design Name: 
-- Module Name: Edge_Detector_top - Behavioral
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


entity Edge_Detector_top is
    Port(dataR : in std_logic_vector(31 downto 0);
         dataW : out std_logic_vector(31 downto 0);
         addr : out std_logic_vector(15 downto 0);
         clk : in std_logic;
         en, we : out std_logic);
end Edge_Detector_top;

architecture Behavioral of Edge_Detector_top is

component Input_cache is
    Port ( RESET : in STD_LOGIC;
           CLK : in STD_LOGIC;
           RCh_Cnt : in STD_LOGIC_VECTOR (1 downto 0);
           R_Sel : in STD_LOGIC_VECTOR (1 downto 0);
           R_en : in STD_LOGIC;
           RAM_in : in STD_LOGIC_VECTOR (31 downto 0);
           Word0, Word1, Word2, Word3, Word4, Word5 : out STD_LOGIC_VECTOR (31 downto 0);
           Word6, Word7, Word8, Word9, Word10, Word11 : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component Output_cache is
    Port ( RESET : in STD_LOGIC;
           CLK : in STD_LOGIC;
           W_Sel : in STD_LOGIC;
           W_En : in STD_LOGIC;
           Word0 : in STD_LOGIC_VECTOR (31 downto 0);
           Word1 : in STD_LOGIC_VECTOR (31 downto 0);
           RAM_out : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component Cache_decoder is
    Port ( 
           WCh_Cnt                                    : in STD_LOGIC_VECTOR (1 downto 0);
           X_Cnt                                      : in STD_LOGIC_VECTOR (7 downto 0);
           Y_Cnt                                      : in STD_LOGIC_VECTOR (8 downto 0);
           Word_in0, Word_in1, Word_in2, Word_in3     : in STD_LOGIC_VECTOR (31 downto 0);
           Word_in4, Word_in5, Word_in6, Word_in7     : in STD_LOGIC_VECTOR (31 downto 0);
           Word_in8, Word_in9, Word_in10, Word_in11   : in STD_LOGIC_VECTOR (31 downto 0);
           Px0, Px1, Px2, Px3, Px4, Px5, Px6, Px7     : out STD_LOGIC_VECTOR (7 downto 0);
           Px8, Px9, Px10, Px11, Px12, Px13           : out STD_LOGIC_VECTOR (7 downto 0);
           Px14, Px15, Px16, Px17                     : out STD_LOGIC_VECTOR (7 downto 0)
           );
end component;

component Control_Logic is
    Port ( WCh_Cnt : out STD_LOGIC_VECTOR (1 downto 0);
           RCh_Cnt : out STD_LOGIC_VECTOR (1 downto 0);
           px_Sel : out STD_LOGIC_VECTOR (1 downto 0);
           clk : in STD_LOGIC;
           RAddr_Cnt : out STD_LOGIC_VECTOR (15 downto 0);
           WAddr_Cnt : out STD_LOGIC_VECTOR (15 downto 0);
           W_Sel : out STD_LOGIC_VECTOR (1 downto 0);
           R_Sel : out STD_LOGIC_VECTOR (1 downto 0);
           R_en : out STD_LOGIC;
           X_Cnt : out std_logic_vector(7 downto 0);
           Y_Cnt : out std_logic_vector(8 downto 0);
           reset : in std_logic;
           start : in STD_LOGIC;
           finish : out STD_LOGIC);
end component;

component clock is
    generic(
        period : time := 50 ns
    );
    port(
        stop : in  std_logic;
        clk  : out std_logic := '0'
    );
end component;

begin


end Behavioral;
