----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/05/2026 11:27:51 AM
-- Design Name: 
-- Module Name: Input_cache - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Input_cache is
    Port ( RESET : in STD_LOGIC;
           CLK : in STD_LOGIC;
           RCh_Cnt : in STD_LOGIC_VECTOR (1 downto 0);
           R_Sel : in STD_LOGIC_VECTOR (1 downto 0);
           R_en : in STD_LOGIC;
           RAM_in : in STD_LOGIC_VECTOR (31 downto 0);
           Word0, Word1, Word2, Word3, Word4, Word5 : out STD_LOGIC_VECTOR (31 downto 0);
           Word6, Word7, Word8, Word9, Word10, Word11 : out STD_LOGIC_VECTOR (31 downto 0));
end Input_cache;

architecture Behavioral of Input_cache is

    -- Components --
    component Reg32 is
        Port ( RESET : in STD_LOGIC;
               CLK : in STD_LOGIC;
               EN0 : in STD_LOGIC;
               EN1 : in STD_LOGIC;
               D_in : in STD_LOGIC_VECTOR (31 downto 0);
               Q_out : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    
    -- Signals --
    signal ChEN : STD_LOGIC_VECTOR (3 downto 0);
    signal RoEN : STD_LOGIC_VECTOR (2 downto 0);

begin
    
    -- Chunk MUX --
    ChMUX: process(RCh_Cnt, R_en, ChEN)
    begin
        ChEN <= "0000";
        case RCh_Cnt is
            when "00" =>
                ChEN(0) <= '1' and R_en;
            when "01" =>
                ChEN(1) <= '1' and R_en;
            when "10" =>
                ChEN(2) <= '1' and R_en;
            when "11" =>
                ChEN(3) <= '1' and R_en;
            when others =>
                ChEN <= "0000";
        end case;
    end process;

    -- Row MUX --
    RMUX: process(R_Sel, R_en, RoEN)
    begin
        RoEN <= "000";
        case R_Sel is
            when "00" =>
                RoEN(0) <= '1' and R_en;
            when "01" =>
                RoEN(1) <= '1' and R_en;
            when "10" =>
                RoEN(2) <= '1' and R_en;
            when others =>
                RoEN <= "000";
        end case;
    end process;
    
    
    -- Chache registers --
    R0: Reg32 port map(
        RESET => RESET, CLK => CLK, EN0 => ChEN(0), EN1 => RoEN(0), D_in => RAM_in, Q_out => Word0);
    
    R1: Reg32 port map(
        RESET => RESET, CLK => CLK, EN0 => ChEN(1), EN1 => RoEN(0), D_in => RAM_in, Q_out => Word1);
    
    R2: Reg32 port map(
        RESET => RESET, CLK => CLK, EN0 => ChEN(2), EN1 => RoEN(0), D_in => RAM_in, Q_out => Word2);
        
    R3: Reg32 port map(
        RESET => RESET, CLK => CLK, EN0 => ChEN(3), EN1 => RoEN(0), D_in => RAM_in, Q_out => Word3);
    
    R4: Reg32 port map(
        RESET => RESET, CLK => CLK, EN0 => ChEN(0), EN1 => RoEN(1), D_in => RAM_in, Q_out => Word4);
    
    R5: Reg32 port map(
        RESET => RESET, CLK => CLK, EN0 => ChEN(1), EN1 => RoEN(1), D_in => RAM_in, Q_out => Word5);
    
    R6: Reg32 port map(
        RESET => RESET, CLK => CLK, EN0 => ChEN(2), EN1 => RoEN(1), D_in => RAM_in, Q_out => Word6);
        
    R7: Reg32 port map(
        RESET => RESET, CLK => CLK, EN0 => ChEN(3), EN1 => RoEN(1), D_in => RAM_in, Q_out => Word7);
    
    R8: Reg32 port map(
        RESET => RESET, CLK => CLK, EN0 => ChEN(0), EN1 => RoEN(2), D_in => RAM_in, Q_out => Word8);
    
    R9: Reg32 port map(
        RESET => RESET, CLK => CLK, EN0 => ChEN(1), EN1 => RoEN(2), D_in => RAM_in, Q_out => Word9);
    
    R10: Reg32 port map(
        RESET => RESET, CLK => CLK, EN0 => ChEN(2), EN1 => RoEN(2), D_in => RAM_in, Q_out => Word10);
        
    R11: Reg32 port map(
        RESET => RESET, CLK => CLK, EN0 => ChEN(3), EN1 => RoEN(2), D_in => RAM_in, Q_out => Word11);
    
    
    
end Behavioral;
