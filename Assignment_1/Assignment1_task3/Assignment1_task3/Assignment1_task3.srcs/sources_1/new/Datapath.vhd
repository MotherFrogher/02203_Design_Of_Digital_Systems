library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gcd_datapath is
    port (
        clk          : in  std_logic;
        reset        : in  std_logic;
        AB           : in  unsigned(15 downto 0);
        load_a       : in  std_logic; 
        load_b       : in  std_logic; 
        sub_a        : in  std_logic; 
        sub_b        : in  std_logic;
        reg_c_enable : in  std_logic;
        a_equal_b    : out std_logic;
        a_greater_b  : out std_logic;
        C            : out unsigned(15 downto 0)
    );
end entity gcd_datapath;

architecture behavioral of gcd_datapath is
    signal reg_a : unsigned(15 downto 0) := (others => '0');
    signal reg_b : unsigned(15 downto 0) := (others => '0');
    signal reg_c : unsigned(15 downto 0) := (others => '0');
begin

    process(clk, reset)
    begin
        if reset = '1' then
            reg_a <= (others => '0');
            reg_b <= (others => '0');
            reg_c <= (others => '0');
        elsif rising_edge(clk) then
            
            if load_a = '1' then
                reg_a <= AB;
            elsif sub_a = '1' then
                reg_a <= reg_a - reg_b;
            end if;

            if load_b = '1' then
                reg_b <= AB;
            elsif sub_b = '1' then
                reg_b <= reg_b - reg_a;
            end if;

            if reg_c_enable = '1' then
                reg_c <= reg_a;
            end if;

        end if;
    end process;

    a_equal_b   <= '1' when (reg_a = reg_b) and (reg_a /= 0) else '0';
    a_greater_b <= '1' when (reg_a > reg_b) else '0';
    C           <= reg_c;

end architecture behavioral;