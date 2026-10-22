library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity GCD_FSMD is
--    generic (
--      n : integer
--    );
    Port(Req, clk, reset: in std_logic;
        AB: in unsigned(15 downto 0);
        C: out unsigned(15 downto 0);
        Ack: out std_logic);
end GCD_FSMD;

architecture Structural of GCD_FSMD is

component Datapath is
    Port (clk: in std_logic;
          AB: in unsigned(15 downto 0);
          ABorALU, LDA, LDB: in std_logic;
          FN: in std_logic_vector(1 downto 0);
          C: out unsigned(15 downto 0);
          N, Z: out std_logic
          );
end component Datapath;

component FSM is
    Port(req, clk, N, Z, reset: in std_logic;
        fn: out std_logic_vector(1 downto 0);
        ABorALU, LDA, LDB, ack: out std_logic);
end component FSM;

signal ABorALU_sig, LDA_sig, LDB_sig, ALB_sig, AGB_sig, EQ_sig, N_sig, Z_sig: std_logic;
signal FN_sig: std_logic_vector(1 downto 0);


begin

U0: Datapath port map(clk => clk, AB => AB, C => C, ABorALU => ABorALU_sig, LDA => LDA_sig, 
                      LDB => LDB_sig, FN => FN_sig,
                      N => N_sig, Z => Z_sig);

U1: FSM port map(clk => clk, req => Req, ack => Ack, reset => reset, N => N_sig, Z => Z_sig,
                 fn => FN_sig, ABorALU => ABorALU_sig,
                 LDA => LDA_sig, LDB => LDB_sig);

end Structural;























