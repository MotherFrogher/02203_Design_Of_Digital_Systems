library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_gcd_top is
end entity tb_gcd_top;

architecture testbench of tb_gcd_top is

    constant CLK_PERIOD : time := 10 ns;
    constant N_PARAM    : integer := 2;

    -- Test vectors
    type t_ops is array (0 to 4) of integer;

    variable a_ops     : t_ops := (91, 32768, 49, 29232, 25);
    variable b_ops     : t_ops := (63, 8192, 98, 488, 5);
    variable c_results : t_ops := (7, 8192, 49, 8, 5);

    -- Signaler til UUT
    signal clk     : std_logic := '0';
    signal reset   : std_logic := '0';
    signal req     : std_logic := '0';
    signal AB      : unsigned(15 downto 0) := (others => '0');
    signal ack     : std_logic;
    signal C       : unsigned(15 downto 0);
    signal reqLED  : std_logic;

    -- Komponentdeklaration
    component gcd_top
        generic (
            n : integer := 20
        );
        port (
            clk    : in  std_logic;
            reset  : in  std_logic;
            req    : in  std_logic;
            AB     : in  unsigned(15 downto 0);
            ack    : out std_logic;
            C      : out unsigned(15 downto 0);
            reqLED : out std_logic
        );
    end component;

begin

    -------------------------------------------------------------------------
    -- 1. Instansiering af Unit Under Test (UUT)
    -------------------------------------------------------------------------
    uut: gcd_top
        generic map (
            n => N_PARAM
        )
        port map (
            clk    => clk,
            reset  => reset,
            req    => req,
            AB     => AB,
            ack    => ack,
            C      => C,
            reqLED => reqLED
        );

    -------------------------------------------------------------------------
    -- 2. Clock generator (100 MHz)
    -------------------------------------------------------------------------
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -------------------------------------------------------------------------
    -- 3. Stimulus process
    -------------------------------------------------------------------------
    stim_proc: process
    begin

        -- System reset
        reset <= '1';
        req   <= '0';
        AB    <= (others => '0');

        wait for CLK_PERIOD * 5;

        reset <= '0';

        wait for CLK_PERIOD * 5;

        ---------------------------------------------------------------------
        -- Test cases
        ---------------------------------------------------------------------
        for i in 0 to 4 loop

            -----------------------------------------------------------------
            -- Send operand A
            -----------------------------------------------------------------
            AB  <= to_unsigned(a_ops(i), 16);
            req <= '1';

            -- Vent på ACK fra FSM efter modtagelse af A
            wait until ack = '1';

            wait for CLK_PERIOD * 2;
            req <= '0';

            wait for CLK_PERIOD * 5;

            -----------------------------------------------------------------
            -- Send operand B
            -----------------------------------------------------------------
            AB  <= to_unsigned(b_ops(i), 16);
            req <= '1';

            -- Vent på ACK efter beregningen er færdig
            wait until ack = '1';

            wait for CLK_PERIOD * 2;
            req <= '0';

            -----------------------------------------------------------------
            -- Verificer resultat
            -----------------------------------------------------------------
            assert C = to_unsigned(c_results(i), 16)
                report "FEJL: gcd("
                    & integer'image(a_ops(i))
                    & ", "
                    & integer'image(b_ops(i))
                    & ") forventede "
                    & integer'image(c_results(i))
                    & ", men fik "
                    & integer'image(to_integer(C))
                severity error;

            -- Ekstra ventetid mellem testcases
            wait for CLK_PERIOD * 30;

        end loop;

        ---------------------------------------------------------------------
        -- Simulation afsluttet
        ---------------------------------------------------------------------
        report "Alle 5 GCD-tests gennemfort succesfuldt!" severity note;

        wait;

    end process;

end architecture testbench;