--------------------------------------------------------------------------------
-- Company:     DTU
-- Engineer:    Christian Brandt Staunsbjerg - s244770@dtu.dk
--
-- Create Date: 11/08/2026
-- Module Name: acc_top_tb - behavioral
-- Description: Testbench for the top-level edge-detection accelerator (acc_top)
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity acc_top_tb is
end acc_top_tb;

architecture behavioral of acc_top_tb is

    -- Component Declaration for the Unit Under Test (UUT)
    component acc_top
        port(
            Px0, Px1, Px2, Px3, Px4, Px5, Px6, Px7, Px8,
            Px9, Px10, Px11, Px12, Px13, Px14, Px15, Px16, Px17 : in  unsigned (7 downto 0);            
            output1, output2, output3, output4                  : out unsigned (7 downto 0)
        );
    end component;

    -- Inputs
    signal Px0  : unsigned(7 downto 0) := (others => '0');
    signal Px1  : unsigned(7 downto 0) := (others => '0');
    signal Px2  : unsigned(7 downto 0) := (others => '0');
    signal Px3  : unsigned(7 downto 0) := (others => '0');
    signal Px4  : unsigned(7 downto 0) := (others => '0');
    signal Px5  : unsigned(7 downto 0) := (others => '0');
    signal Px6  : unsigned(7 downto 0) := (others => '0');
    signal Px7  : unsigned(7 downto 0) := (others => '0');
    signal Px8  : unsigned(7 downto 0) := (others => '0');
    signal Px9  : unsigned(7 downto 0) := (others => '0');
    signal Px10 : unsigned(7 downto 0) := (others => '0');
    signal Px11 : unsigned(7 downto 0) := (others => '0');
    signal Px12 : unsigned(7 downto 0) := (others => '0');
    signal Px13 : unsigned(7 downto 0) := (others => '0');
    signal Px14 : unsigned(7 downto 0) := (others => '0');
    signal Px15 : unsigned(7 downto 0) := (others => '0');
    signal Px16 : unsigned(7 downto 0) := (others => '0');
    signal Px17 : unsigned(7 downto 0) := (others => '0');

    -- Outputs
    signal output1 : unsigned(7 downto 0);
    signal output2 : unsigned(7 downto 0);
    signal output3 : unsigned(7 downto 0);
    signal output4 : unsigned(7 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: acc_top port map (
        Px0     => Px0,
        Px1     => Px1,
        Px2     => Px2,
        Px3     => Px3,
        Px4     => Px4,
        Px5     => Px5,
        Px6     => Px6,
        Px7     => Px7,
        Px8     => Px8,
        Px9     => Px9,
        Px10    => Px10,
        Px11    => Px11,
        Px12    => Px12,
        Px13    => Px13,
        Px14    => Px14,
        Px15    => Px15,
        Px16    => Px16,
        Px17    => Px17,
        output1 => output1,
        output2 => output2,
        output3 => output3,
        output4 => output4
    );

    -- Stimulus process
    stim_proc: process
    begin
        -- Sæt initial-værdier (første 9 pixels matcher dit tidligere 3x3 eksempel for ACC_1)
        Px0  <= to_unsigned(191, 8);
        Px1  <= to_unsigned(138, 8);
        Px2  <= to_unsigned(109, 8);
        Px3  <= to_unsigned(40,  8);
        Px4  <= to_unsigned(123, 8);
        Px5  <= to_unsigned(38,  8);
        Px6  <= to_unsigned(233, 8);
        Px7  <= to_unsigned(132, 8);
        Px8  <= to_unsigned(183, 8);
        
        -- Værdier til de resterende pixels (Px9 til Px17) for at fodre ACC_2, ACC_3 og ACC_4
        Px9  <= to_unsigned(50,  8);
        Px10 <= to_unsigned(100, 8);
        Px11 <= to_unsigned(150, 8);
        Px12 <= to_unsigned(200, 8);
        Px13 <= to_unsigned(75,  8);
        Px14 <= to_unsigned(125, 8);
        Px15 <= to_unsigned(60,  8);
        Px16 <= to_unsigned(110, 8);
        Px17 <= to_unsigned(90,  8);

        -- Vent i et par 100 ns for at lade resultatet propagere igennem
        wait for 100 ns;

        -- Her kan du evt. ændre pixel-værdierne for at teste et nyt sæt data
        -- Px0 <= to_unsigned(..., 8);
        -- ...

        wait;
    end process;

end behavioral;