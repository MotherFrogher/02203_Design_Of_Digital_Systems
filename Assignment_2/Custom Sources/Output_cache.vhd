----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/19/2026 10:43:51 AM
-- Design Name: 
-- Module Name: Output_cache - Behavioral
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

entity Output_cache is
    Port ( RESET : in STD_LOGIC;
           CLK : in STD_LOGIC;
           W_Sel : in STD_LOGIC_VECTOR (1 downto 0);
           W_En : in STD_LOGIC;
           Word0 : in STD_LOGIC_VECTOR (31 downto 0);
           Word1 : in STD_LOGIC_VECTOR (31 downto 0);
           RAM_out : out STD_LOGIC_VECTOR (31 downto 0));
end Output_cache;

architecture Behavioral of Output_cache is

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
    signal CEn : STD_LOGIC_VECTOR (1 downto 0);
    signal RAM0, RAM1 : STD_LOGIC_VECTOR (31 downto 0);

begin

    -- Cache MUX --
    CMUX: process(W_Sel, W_en, CEn)
    begin
        CEn <= "00";
        case W_sel is
            when "01" =>
                CEn(0) <= '1' and W_en;
            when "10" =>
                CEn(1) <= '1' and W_en;
            when others =>
                CEn <= "00";
        end case;
    end process;

    -- Chache registers --
    R0: Reg32 port map(
        RESET => RESET, CLK => CLK, EN0 => CEn(0), EN1 => '1', D_in => Word0, Q_out => RAM0);
    
    R1: Reg32 port map(
        RESET => RESET, CLK => CLK, EN0 => CEn(1), EN1 => '1', D_in => Word1, Q_out => RAM1);

    -- Output MUX --
    OMUX: process(W_Sel, RAM0, RAM1)
    begin
        case W_sel is
            when "01" =>
                RAM_out <= RAM0;
            when "10" =>
                RAM_out <= RAM1;
            when others =>
                RAM_out <= RAM0;
        end case;
    end process;

end Behavioral;
