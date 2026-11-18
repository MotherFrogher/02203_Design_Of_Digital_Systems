library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Cache_decoder_tb is
end Cache_decoder_tb;

architecture Behavioral of Cache_decoder_tb is

    ------------------------------------------------------------------
    -- DUT Signals
    ------------------------------------------------------------------

    signal WCh_Cnt : STD_LOGIC_VECTOR(1 downto 0);

    signal Word_in0, Word_in1, Word_in2, Word_in3     : STD_LOGIC_VECTOR(31 downto 0);
    signal Word_in4, Word_in5, Word_in6, Word_in7     : STD_LOGIC_VECTOR(31 downto 0);
    signal Word_in8, Word_in9, Word_in10, Word_in11   : STD_LOGIC_VECTOR(31 downto 0);

    signal Px0, Px1, Px2, Px3, Px4, Px5, Px6, Px7     : STD_LOGIC_VECTOR(7 downto 0);
    signal Px8, Px9, Px10, Px11, Px12, Px13           : STD_LOGIC_VECTOR(7 downto 0);
    signal Px14, Px15, Px16, Px17                     : STD_LOGIC_VECTOR(7 downto 0);

begin

    ------------------------------------------------------------------
    -- Instantiate DUT
    ------------------------------------------------------------------

    DUT : entity work.Cache_decoder
    port map (
        WCh_Cnt => WCh_Cnt,

        Word_in0  => Word_in0,
        Word_in1  => Word_in1,
        Word_in2  => Word_in2,
        Word_in3  => Word_in3,
        Word_in4  => Word_in4,
        Word_in5  => Word_in5,
        Word_in6  => Word_in6,
        Word_in7  => Word_in7,
        Word_in8  => Word_in8,
        Word_in9  => Word_in9,
        Word_in10 => Word_in10,
        Word_in11 => Word_in11,

        Px0  => Px0,
        Px1  => Px1,
        Px2  => Px2,
        Px3  => Px3,
        Px4  => Px4,
        Px5  => Px5,
        Px6  => Px6,
        Px7  => Px7,
        Px8  => Px8,
        Px9  => Px9,
        Px10 => Px10,
        Px11 => Px11,
        Px12 => Px12,
        Px13 => Px13,
        Px14 => Px14,
        Px15 => Px15,
        Px16 => Px16,
        Px17 => Px17
    );

    ------------------------------------------------------------------
    -- Stimulus
    ------------------------------------------------------------------

    stim_proc : process
    begin

        -- Top row chunks
        Word_in0 <= x"03020100";
        Word_in1 <= x"07060504";
        Word_in2 <= x"0B0A0908";
        Word_in3 <= x"0F0E0D0C";

        -- Middle row chunks
        Word_in4 <= x"13121110";
        Word_in5 <= x"17161514";
        Word_in6 <= x"1B1A1918";
        Word_in7 <= x"1F1E1D1C";

        -- Bottom row chunks
        Word_in8  <= x"23222120";
        Word_in9  <= x"27262524";
        Word_in10 <= x"2B2A2928";
        Word_in11 <= x"2F2E2D2C";

        --------------------------------------------------------------
        -- Chunk 0
        --------------------------------------------------------------
        WCh_Cnt <= "00";
        wait for 20 ns;

        --------------------------------------------------------------
        -- Chunk 1
        --------------------------------------------------------------
        WCh_Cnt <= "01";
        wait for 20 ns;

        --------------------------------------------------------------
        -- Chunk 2
        --------------------------------------------------------------
        WCh_Cnt <= "10";
        wait for 20 ns;

        --------------------------------------------------------------
        -- Chunk 3
        --------------------------------------------------------------
        WCh_Cnt <= "11";
        wait for 20 ns;

        wait;

    end process;

end Behavioral;