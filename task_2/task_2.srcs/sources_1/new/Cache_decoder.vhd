library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Cache_decoder is
    Port ( 
           WCh_Cnt                                    : in STD_LOGIC_VECTOR (1 downto 0);
           Word_in0, Word_in1, Word_in2, Word_in3     : in STD_LOGIC_VECTOR (31 downto 0);
           Word_in4, Word_in5, Word_in6, Word_in7     : in STD_LOGIC_VECTOR (31 downto 0);
           Word_in8, Word_in9, Word_in10, Word_in11   : in STD_LOGIC_VECTOR (31 downto 0);
           Px0, Px1, Px2, Px3, Px4, Px5, Px6, Px7     : out STD_LOGIC_VECTOR (7 downto 0);
           Px8, Px9, Px10, Px11, Px12, Px13           : out STD_LOGIC_VECTOR (7 downto 0);
           Px14, Px15, Px16, Px17                     : out STD_LOGIC_VECTOR (7 downto 0)
           );
end Cache_decoder;

architecture Behavioral of Cache_decoder is


signal Top_Left, Top_Center, Top_Right : std_logic_vector(31 downto 0);
signal Mid_Left, Mid_Center, Mid_Right : std_logic_vector(31 downto 0);
signal Bot_Left, Bot_Center, Bot_Right : std_logic_vector(31 downto 0);

begin

process(WCh_Cnt, Word_in0, Word_in1, Word_in2, Word_in3,
Word_in4, Word_in5, Word_in6, Word_in7,Word_in8, Word_in9,
Word_in10, Word_in11)

begin


-----------------------------------------------------------------
-- Deafault values
-----------------------------------------------------------------
Top_Left   <= (others => '0');
Top_Center <= (others => '0');
Top_Right  <= (others => '0');

Mid_Left   <= (others => '0');
Mid_Center <= (others => '0');
Mid_Right  <= (others => '0');

Bot_Left   <= (others => '0');
Bot_Center <= (others => '0');
Bot_Right  <= (others => '0');

case WCh_Cnt is 
when "00" =>

-----------------------------------------------------------------
-- Chunk 0 selected
-----------------------------------------------------------------
Top_Left   <= Word_in3;
Top_Center <= Word_in0;
Top_Right  <= Word_in1;

Mid_Left   <= Word_in7;
Mid_Center <= Word_in4;
Mid_Right  <= Word_in5;

Bot_Left   <= Word_in11;
Bot_Center <= Word_in8;
Bot_Right  <= Word_in9;

-----------------------------------------------------------------
-- Chunk 1 selected
-----------------------------------------------------------------
when "01" =>

Top_Left   <= Word_in0;
Top_Center <= Word_in1;
Top_Right  <= Word_in2;

Mid_Left   <= Word_in4;
Mid_Center <= Word_in5;
Mid_Right  <= Word_in6;

Bot_Left   <= Word_in8;
Bot_Center <= Word_in9;
Bot_Right  <= Word_in10;

-----------------------------------------------------------------
-- Chunk 2 selected
-----------------------------------------------------------------
when "10" =>

Top_Left   <= Word_in1;
Top_Center <= Word_in2;
Top_Right  <= Word_in3;


Mid_Left   <= Word_in5;
Mid_Center <= Word_in6;
Mid_Right  <= Word_in7;

Bot_Left   <= Word_in9;
Bot_Center <= Word_in10;
Bot_Right  <= Word_in11;

-----------------------------------------------------------------
-- Chunk 3 selected
-----------------------------------------------------------------
when others =>

Top_Left   <= Word_in2;
Top_Center <= Word_in3;
Top_Right  <= Word_in0;

Mid_Left   <= Word_in6;
Mid_Center <= Word_in7;
Mid_Right  <= Word_in4;

Bot_Left   <= Word_in10;
Bot_Center <= Word_in11;
Bot_Right  <= Word_in8;

end case;

end process;

-----------------------------------------------------------------
-- Pixel extraction
-----------------------------------------------------------------

-- Top row
Px0 <= Top_Left(31 downto 24);

Px1 <= Top_Center(7 downto 0);
Px2 <= Top_Center(15 downto 8);
Px3 <= Top_Center(23 downto 16);
Px4 <= Top_Center(31 downto 24);

Px5 <= Top_Right(7 downto 0);

-- Middle row
Px6  <= Mid_Left(31 downto 24);

Px7  <= Mid_Center(7 downto 0);
Px8  <= Mid_Center(15 downto 8);
Px9  <= Mid_Center(23 downto 16);
Px10 <= Mid_Center(31 downto 24);

Px11 <= Mid_Right(7 downto 0);

-- Bottom row
Px12 <= Bot_Left(31 downto 24);

Px13 <= Bot_Center(7 downto 0);
Px14 <= Bot_Center(15 downto 8);
Px15 <= Bot_Center(23 downto 16);
Px16 <= Bot_Center(31 downto 24);

Px17 <= Bot_Right(7 downto 0);

end Behavioral;