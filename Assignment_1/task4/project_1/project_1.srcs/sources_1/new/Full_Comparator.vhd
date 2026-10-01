library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Full_Comparator is
    Port(a, b: in unsigned(15 downto 0);
        AGB, ALB, EQ: out std_logic);
end Full_Comparator;

architecture Behavioral of Full_Comparator is

signal EQ_sig, ALB_sig: std_logic;

begin
EQ_sig <= '1' when a = b else '0';

ALB_sig <= '1' when a < b else '0';

EQ <= EQ_sig;
ALB <= ALB_sig;
AGB <= not(EQ_sig or ALB_sig);
end Behavioral;
