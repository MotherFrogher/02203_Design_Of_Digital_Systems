----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/05/2026 11:36:58 AM
-- Design Name: 
-- Module Name: Reg32 - Behavioral
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

entity Reg32 is
    Port ( RESET : in STD_LOGIC;
           CLK : in STD_LOGIC;
           EN0 : in STD_LOGIC;
           EN1 : in STD_LOGIC;
           D_in : in STD_LOGIC_VECTOR (31 downto 0);
           Q_out : out STD_LOGIC_VECTOR (31 downto 0));
end Reg32;

architecture Behavioral of Reg32 is
begin

    process(RESET, CLK) is
    begin
        if RESET = '0' then
            Q_out <= x"00000000";
        elsif rising_edge(CLK) then
            if EN0 = '1' and EN1 = '1' then
                Q_out <= D_in;
            end if;
        end if;
    end process;

end Behavioral;
