-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Control_Logic_tb is
end;

architecture bench of Control_Logic_tb is

  component Control_Logic
    Port ( WCh_Cnt : out STD_LOGIC_VECTOR (1 downto 0);
           RCh_Cnt : out STD_LOGIC_VECTOR (1 downto 0);
           px_Sel : out STD_LOGIC_VECTOR (1 downto 0);
           clk : in STD_LOGIC;
           Addr : out STD_LOGIC_VECTOR (15 downto 0);
           W_Sel : out STD_LOGIC_VECTOR (1 downto 0);
           R_Sel : out STD_LOGIC_VECTOR (1 downto 0);
           X_Cnt : out std_logic_vector (7 downto 0);
           Y_Cnt : out std_logic_vector (8 downto 0);
           R_en : out STD_LOGIC;
           W_en : out std_logic;
           reset : in std_logic;
           start : in STD_LOGIC;
           finish : out STD_LOGIC);
  end component;

  signal WCh_Cnt: STD_LOGIC_VECTOR (1 downto 0);
  signal RCh_Cnt: STD_LOGIC_VECTOR (1 downto 0);
  signal px_Sel: STD_LOGIC_VECTOR (1 downto 0);
  signal clk: STD_LOGIC;
  signal Addr: STD_LOGIC_VECTOR (15 downto 0);
  signal W_Sel: STD_LOGIC_VECTOR (1 downto 0);
  signal R_Sel: STD_LOGIC_VECTOR (1 downto 0);
  signal X_Cnt : std_logic_vector (7 downto 0);
  signal Y_Cnt : std_logic_vector (8 downto 0);
  signal R_en: STD_LOGIC;
  signal W_en: std_logic;
  signal reset: std_logic;
  signal start: STD_LOGIC;
  signal finish: STD_LOGIC;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: Control_Logic port map ( WCh_Cnt   => WCh_Cnt,
                                RCh_Cnt  => RCh_Cnt,
                                px_Sel    => px_Sel,
                                clk       => clk,
                                Addr      => Addr,
                                W_Sel     => W_Sel,
                                R_Sel     => R_Sel,
                                X_Cnt     => X_Cnt,
                                Y_Cnt     => Y_Cnt,
                                R_en      => R_en,
                                W_en      => W_en,
                                reset     => reset,
                                start     => start,
                                finish    => finish );

  stimulus: process
  begin

  start <= '0';
  reset <= '0';
  wait for 25 ns;                       -- hold reset over a few clock edges
  reset <= '1';
  wait for 20 ns;

  start <= '1';                         -- one-clock start pulse
  wait for clock_period;
  start <= '0';

  wait until finish = '1';     -- ~101,400 cycles = ~1.02 ms
  wait for 2 * clock_period;            -- so the finish pulse shows in the waveform
  stop_the_clock <= true;               -- clock process exits, no more events
  wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;