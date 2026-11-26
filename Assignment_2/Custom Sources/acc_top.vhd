library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity acc_top is
    port(
        Px0,Px1,Px2,Px3,Px4,Px5,Px6,Px7,Px8,Px9 : in  std_logic_vector(7 downto 0);
        Px10,Px11,Px12,Px13,Px14,Px15,Px16,Px17 : in  std_logic_vector(7 downto 0);
        px_Sel : in  std_logic_vector(1 downto 0);
        OUTPUT : out std_logic_vector(31 downto 0)
    );
end acc_top;

architecture Behavioral of acc_top is

    component acc
        port(
        Px0,Px1,Px2,Px3,Px4,Px5,Px6,Px7,Px8 : in  unsigned (7 downto 0);
        output                              : out unsigned (7 downto 0)
        );
    end component acc;

signal OUTPUT_MUX : unsigned(31 downto 0);
signal output1_sig, output2_sig, output3_sig, output4_sig : unsigned(7 downto 0);

begin


-- DISABLED IF PX MIRRORING WORKS
-- "11" = Discard all pixels, "10" = Discard left px
-- "01" = Discard right px, "00" = Discard no px.
OUTPUT_MUX <= (others => '0') when px_Sel = "11" else
              output4_sig & output3_sig & output2_sig & x"00" when px_Sel = "10" else
              x"00" & output3_sig & output2_sig & output1_sig when px_Sel = "01" else
              output4_sig & output3_sig & output2_sig & output1_sig;
              

OUTPUT <= std_logic_vector(OUTPUT_MUX);

    ACC_1 : acc
        port map(
            Px0    => unsigned(Px0),
            Px1    => unsigned(Px1),
            Px2    => unsigned(Px2),
            Px3    => unsigned(Px6),
            Px4    => unsigned(Px7),
            Px5    => unsigned(Px8),
            Px6    => unsigned(Px12),
            Px7    => unsigned(Px13),
            Px8    => unsigned(Px14),
            output => output1_sig
        );
    ACC_2 : acc
        port map(
            Px0    => unsigned(Px1),
            Px1    => unsigned(Px2),
            Px2    => unsigned(Px3),
            Px3    => unsigned(Px7),
            Px4    => unsigned(Px8),
            Px5    => unsigned(Px9),
            Px6    => unsigned(Px13),
            Px7    => unsigned(Px14),
            Px8    => unsigned(Px15),
            output => output2_sig
        );
    ACC_3 : acc
        port map(
            Px0    => unsigned(Px2),
            Px1    => unsigned(Px3),
            Px2    => unsigned(Px4),
            Px3    => unsigned(Px8),
            Px4    => unsigned(Px9),
            Px5    => unsigned(Px10),
            Px6    => unsigned(Px14),
            Px7    => unsigned(Px15),
            Px8    => unsigned(Px16),
            output => output3_sig
        );
    ACC_4 : acc
        port map(
            Px0    => unsigned(Px3),
            Px1    => unsigned(Px4),
            Px2    => unsigned(Px5),
            Px3    => unsigned(Px9),
            Px4    => unsigned(Px10),
            Px5    => unsigned(Px11),
            Px6    => unsigned(Px15),
            Px7    => unsigned(Px16),
            Px8    => unsigned(Px17),
            output => output4_sig
        );

end Behavioral;