library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_gcd_top is
-- Testbench har ingen porte
end entity tb_gcd_top;

architecture testbench of tb_gcd_top is

    -- Konstant for clock period (f.eks. 100 MHz -> 10 ns)
    constant CLK_PERIOD : time := 10 ns;

    -- Generisk n sat lavt i testbench for hurtigere debounce-simulation
    constant N_PARAM    : integer := 2;

    -- Signaler til at forbinde til UUT (Unit Under Test)
    signal clk     : std_logic := '0';
    signal reset   : std_logic := '0';
    signal req     : std_logic := '0';
    signal AB      : unsigned(15 downto 0) := (others => '0');
    signal ack     : std_logic;
    signal C       : unsigned(15 downto 0);
    signal reqLED  : std_logic;

    -- Komponentdeklaration af gcd_top
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

    -----------------------------------------------------------------------------
    -- 1. Instansiering af Unit Under Test (UUT)
    -----------------------------------------------------------------------------
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

    -----------------------------------------------------------------------------
    -- 2. Clock generator (100 MHz)
    -----------------------------------------------------------------------------
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -----------------------------------------------------------------------------
    -- 3. Stimulus process
    -----------------------------------------------------------------------------
    stim_proc: process
    begin
        -- System reset
        reset <= '1';
        req   <= '0';
        AB    <= (others => '0');
        wait for CLK_PERIOD * 5;
        reset <= '0';
        wait for CLK_PERIOD * 5;

        -------------------------------------------------------------------------
        -- BEREGNING 1: gcd(48, 18) = 6
        -------------------------------------------------------------------------
        -- 1a. Send operand A = 48
        AB  <= to_unsigned(15, 16);
        req <= '1';
        
        -- Vent på første Ack fra FSM (State 2)
        wait until ack = '1';
        wait for CLK_PERIOD * 2;
        req <= '0';
        wait for CLK_PERIOD * 5;

        -- 1b. Send operand B = 18 og start beregning
        AB  <= to_unsigned(7, 16);
        req <= '1';

        -- Vent på at beregningen færdiggøres og Ack sættes højt (State 8)
        wait until ack = '1';
        wait for CLK_PERIOD * 2;
        req <= '0';

        -- Verificer resultatet i konsollen
        assert C = 6
            report "FEJL: gcd(15, 7) forventede 1, men fik " & integer'image(to_integer(C))
            severity error;

        wait for CLK_PERIOD * 30;

        -------------------------------------------------------------------------
        -- BEREGNING 2: gcd(35, 15) = 5
        -------------------------------------------------------------------------
        -- 2a. Send operand A = 35
        AB  <= to_unsigned(35, 16);
        req <= '1';

        wait until ack = '1';
        wait for CLK_PERIOD * 2;
        req <= '0';
        wait for CLK_PERIOD * 5;

        -- 2b. Send operand B = 15
        AB  <= to_unsigned(15, 16);
        req <= '1';

        wait until ack = '1';
        wait for CLK_PERIOD * 2;
        req <= '0';

        -- Verificer resultatet
        assert C = 5
            report "FEJL: gcd(35, 15) forventede 5, men fik " & integer'image(to_integer(C))
            severity error;

        -------------------------------------------------------------------------
        -- Slut på simulation
        -------------------------------------------------------------------------
        report "Simulation gennemfort succesfuldt!" severity note;
        wait;
    end process;

end architecture testbench;