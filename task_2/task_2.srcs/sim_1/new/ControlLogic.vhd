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
           RAddr_Cnt : out STD_LOGIC_VECTOR (15 downto 0);
           WAddr_Cnt : out STD_LOGIC_VECTOR (15 downto 0);
           W_Sel : out STD_LOGIC_VECTOR (1 downto 0);
           R_Sel : out STD_LOGIC_VECTOR (1 downto 0);
           R_en : out STD_LOGIC;
           reset : in std_logic;
           start : in STD_LOGIC;
           finish : out STD_LOGIC);
  end component;

  signal WCh_Cnt: STD_LOGIC_VECTOR (1 downto 0);
  signal RCh_Cnt: STD_LOGIC_VECTOR (1 downto 0);
  signal px_Sel: STD_LOGIC_VECTOR (1 downto 0);
  signal clk: STD_LOGIC;
  signal RAddr_Cnt: STD_LOGIC_VECTOR (15 downto 0);
  signal WAddr_Cnt: STD_LOGIC_VECTOR (15 downto 0);
  signal W_Sel: STD_LOGIC_VECTOR (1 downto 0);
  signal R_Sel: STD_LOGIC_VECTOR (1 downto 0);
  signal R_en: STD_LOGIC;
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
                                RAddr_Cnt => RAddr_Cnt,
                                WAddr_Cnt => WAddr_Cnt,
                                W_Sel     => W_Sel,
                                R_Sel     => R_Sel,
                                R_en      => R_en,
                                reset     => reset,
                                start     => start,
                                finish    => finish );

  stimulus: process
  begin

    -- Put initialisation code here

    reset <= '0';
    wait for 5 ns;
    reset <= '1';
    wait for 5 ns;
    start <= '1';
    wait for 10 ns;
    start <= '0';
    wait for 30 ms;

    -- Put test bench stimulus code here

    stop_the_clock <= true;
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