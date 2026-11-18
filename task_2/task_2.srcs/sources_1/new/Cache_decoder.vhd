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
           X_Cnt                                      : in STD_LOGIC_VECTOR (7 downto 0);
           Y_Cnt                                      : in STD_LOGIC_VECTOR (9 downto 0);
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

signal top_edge, bot_edge, right_edge, left_edge : std_logic;
signal T_left, T_center, T_Right : std_logic_vector(31 downto 0);
signal B_left, B_center, B_right : std_logic_vector(31 downto 0);
begin

-- Detection for Top, Bot, Left, Right edges of the image
top_edge <= '1' when Y_cnt = x"000" else '0'; -- When y = 0
bot_edge <= '1' when Y_cnt = x"11F" else '0'; -- When y = 287
left_edge <= '1' when X_cnt = x"00" else '0'; -- When x = 0
right_edge <= '1' when X_cnt = x"57" else '0'; -- When x = 87


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


---- In middle sections wrap around ------    
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
-- Mirror Edges logic
-----------------------------------------------------------------

-- When top edge is detected copy mid row to top
T_Left <= Mid_left when top_edge = '1' else Top_Left;
T_Center <= Mid_center when top_edge = '1' else Top_center; 
T_Right <= Mid_Right when top_edge = '1' else Top_Right;

-- When bottom edge is detected copy mid row to bottom
B_left <= Mid_left when bot_edge = '1' else Bot_left;
B_center <= Mid_center when bot_edge ='1' else Bot_center;
B_Right <= Mid_right when bot_edge = '1' else bot_Right;

-----------------------------------------------------------------
-- Pixel extraction
-----------------------------------------------------------------

-- Top row
-- All gets checked if they are in top edge from T_center

-- If at left edge and top edge, copy the mid center to top left pixel since its a corner
Px0 <= T_Center(7 downto 0) when left_edge ='1' else T_Left(31 downto 24);

Px1 <= T_center(7 downto 0);
Px2 <= T_Center(15 downto 8);
Px3 <= T_Center(23 downto 16);
Px4 <= T_Center(31 downto 24);

-- If at right edge and top edge, copy the mid center to top right pixel since its a corner
Px5 <= T_center(31 downto 24) when right_edge = '1' else T_Right(7 downto 0);

-- Middle row
-- If at left edge copy the center instead
Px6  <= Mid_center(7 downto 0) when left_edge = '1' else Mid_Left(31 downto 24);

Px7  <= Mid_Center(7 downto 0);
Px8  <= Mid_Center(15 downto 8);
Px9  <= Mid_Center(23 downto 16);
Px10 <= Mid_Center(31 downto 24);

--if at right edge copy the center instead
Px11 <= Mid_center(31 downto 24) when right_edge = '1' else Mid_Right(7 downto 0);

-- Bottom row
-- All are checked if they are on bot_edge

-- If at left edge and bottom edge copy the bottom center since its a corner
Px12 <= B_center(7 downto 0) when left_edge = '1' else B_Left(31 downto 24);

Px13 <= B_Center(7 downto 0);
Px14 <= B_Center(15 downto 8);
Px15 <= B_Center(23 downto 16);
Px16 <= B_Center(31 downto 24);

--if at right edge and bot edge copy mid center since its a corner
Px17 <= B_center(31 downto 24) when right_edge = '1' else B_Right(7 downto 0);

end Behavioral;