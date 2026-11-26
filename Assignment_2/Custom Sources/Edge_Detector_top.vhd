library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Edge_Detector_top is
    Port(dataR : in std_logic_vector(31 downto 0);
         dataW : out std_logic_vector(31 downto 0);
         addr : out std_logic_vector(15 downto 0);
         clk : in std_logic;
         reset : in std_logic;
         start : in std_logic;
         finish : out std_logic;
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
           W_Sel : in STD_LOGIC_VECTOR (1 downto 0);
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
           Addr : out STD_LOGIC_VECTOR(15 downto 0);
           W_Sel : out STD_LOGIC_VECTOR (1 downto 0);
           R_Sel : out STD_LOGIC_VECTOR (1 downto 0);
           R_en : out STD_LOGIC;
           W_en : out std_logic;
           X_Cnt : out std_logic_vector(7 downto 0);
           Y_Cnt : out std_logic_vector(8 downto 0);
           reset : in std_logic;
           start : in STD_LOGIC;
           finish : out STD_LOGIC);
end component;

component acc_top is
    port(
        Px0,Px1,Px2,Px3,Px4,Px5,Px6,Px7,Px8,Px9,Px10,Px11,Px12,Px13,Px14,Px15,Px16,Px17: in  std_logic_vector (7 downto 0);            
        px_Sel : in std_logic_vector(1 downto 0);
        OUTPUT : out std_logic_vector(31 downto 0)
    );
end component;

--All signals
signal WCh_Cnt_sig, RCh_Cnt_sig, px_Sel_sig, W_Sel_sig, R_Sel_sig : std_logic_vector(1 downto 0);
signal R_en_sig, W_en_sig : std_logic;
signal X_Cnt_sig : std_logic_vector(7 downto 0);
signal Y_Cnt_sig : std_logic_vector(8 downto 0);

signal Word0_sig, Word1_sig, Word2_sig, Word3_sig, Word4_sig, Word5_sig : std_logic_vector(31 downto 0);
signal Word6_sig, Word7_sig, Word8_sig, Word9_sig, Word10_sig, Word11_sig : std_logic_vector(31 downto 0);

signal WordOut : std_logic_vector(31 downto 0);

signal px0sig, px1sig, px2sig, px3sig, px4sig, px5sig, px6sig, px7sig : std_logic_vector(7 downto 0);
signal px8sig, px9sig, px10sig, px11sig, px12sig, px13sig, px14sig : std_logic_vector(7 downto 0);
signal px15sig, px16sig, px17sig : std_logic_vector(7 downto 0);

begin

en <= R_en_sig;
we <= W_en_sig;

U0: Control_Logic port map(
                    WCh_Cnt => WCh_Cnt_sig,
                    RCh_Cnt => RCh_Cnt_sig,
                    px_Sel => px_Sel_sig,
                    clk => clk,
                    Addr => addr,
                    W_Sel => W_Sel_sig,
                    R_Sel => R_Sel_sig,
                    R_en => R_en_sig,
                    W_en => W_en_sig,
                    X_Cnt => X_Cnt_sig,
                    Y_Cnt => Y_Cnt_sig,
                    reset => reset,
                    start => start,
                    finish => finish
                    );

U1: Input_cache port map(
                    RESET => reset,
                    CLK => clk,
                    RCh_Cnt => RCh_Cnt_sig,
                    R_Sel => R_Sel_sig,
                    R_en => R_en_sig,
                    RAM_in => dataR,
                    Word0 => Word0_sig,
                    Word1 => Word1_sig,
                    Word2 => Word2_sig,
                    Word3 => Word3_sig,
                    Word4 => Word4_sig,
                    Word5 => Word5_sig,
                    Word6 => Word6_sig,
                    Word7 => Word7_sig,
                    Word8 => Word8_sig,
                    Word9 => Word9_sig,
                    Word10 => Word10_sig,
                    Word11 => Word11_sig
                    );

--dataW <= WordOut;

U2: Output_cache port map(
                    RESET => reset,
                    CLK => clk,
                    W_Sel => W_Sel_sig,
                    W_En => W_En_sig,
                    Word0 => WordOut,
                    Word1 => WordOut,
                    RAM_out => dataW
                    );
                    
U3: Cache_decoder port map(
                    WCh_Cnt => WCh_Cnt_sig,
                    X_Cnt => X_Cnt_sig,
                    Y_Cnt => Y_Cnt_sig,
                    Word_in0 => Word0_sig,
                    Word_in1 => Word1_sig,
                    Word_in2 => Word2_sig,
                    Word_in3 => Word3_sig,
                    Word_in4 => Word4_sig,
                    Word_in5 => Word5_sig,
                    Word_in6 => Word6_sig,
                    Word_in7 => Word7_sig,
                    Word_in8 => Word8_sig,
                    Word_in9 => Word9_sig,
                    Word_in10 => Word10_sig,
                    Word_in11 => Word11_sig,
                    Px0 => px0sig,
                    Px1 => px1sig,
                    Px2 => px2sig,
                    Px3 => px3sig,
                    Px4 => px4sig,
                    Px5 => px5sig,
                    Px6 => px6sig,
                    Px7 => px7sig,
                    Px8 => px8sig,
                    Px9 => px9sig,
                    Px10 => px10sig,
                    Px11 => px11sig,
                    Px12 => px12sig,
                    Px13 => px13sig,
                    Px14 => px14sig,
                    Px15 => px15sig,
                    Px16 => px16sig,
                    Px17 => px17sig
                    );
                    
U4: acc_top port map(
                    Px0 => px0sig,
                    Px1 => px1sig,
                    Px2 => px2sig,
                    Px3 => px3sig,
                    Px4 => px4sig,
                    Px5 => px5sig,
                    Px6 => px6sig,
                    Px7 => px7sig,
                    Px8 => px8sig,
                    Px9 => px9sig,
                    Px10 => px10sig,
                    Px11 => px11sig,
                    Px12 => px12sig,
                    Px13 => px13sig,
                    Px14 => px14sig,
                    Px15 => px15sig,
                    Px16 => px16sig,
                    Px17 => px17sig,
                    px_Sel => px_Sel_sig,
                    OUTPUT => WordOut
                    );

end Behavioral;
