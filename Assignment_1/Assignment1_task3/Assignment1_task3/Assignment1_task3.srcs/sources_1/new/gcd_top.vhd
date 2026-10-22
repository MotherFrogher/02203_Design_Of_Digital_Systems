library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gcd_top is
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
end gcd_top;

architecture structural of gcd_top is

    component debounce
        generic (
            n : integer
        );
        port (
            clk      : in  std_logic;
            reset    : in  std_logic;
            sw       : in  std_logic;
            db_level : out std_logic;
            db_tick  : out std_logic
        );
    end component;

    component gcd_fsm
        port (
            clk          : in  std_logic;
            reset        : in  std_logic;
            req          : in  std_logic;
            ack          : out std_logic;
            a_equal_b    : in  std_logic;
            a_greater_b  : in  std_logic;
            load_a       : out std_logic;
            load_b       : out std_logic;
            sub_a        : out std_logic;
            sub_b        : out std_logic;
            reg_c_enable : out std_logic
        );
    end component;

    component gcd_datapath
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
    end component;

    signal db_req   : std_logic;
    signal load_a   : std_logic;
    signal load_b   : std_logic;
    signal sub_a    : std_logic;
    signal sub_b    : std_logic;
    signal reg_c_en : std_logic;
    signal a_eq_b   : std_logic;
    signal a_gt_b   : std_logic;

begin

    u_debounce : debounce 
        generic map (n => n) 
        port map (
            clk      => clk, 
            reset    => reset, 
            sw       => req, 
            db_level => reqLED, 
            db_tick  => db_req
        );

    u_fsm : gcd_fsm
        port map (
            clk          => clk,
            reset        => reset,
            req          => db_req,
            ack          => ack,
            a_equal_b    => a_eq_b,
            a_greater_b  => a_gt_b,
            load_a       => load_a,
            load_b       => load_b,
            sub_a        => sub_a,
            sub_b        => sub_b,
            reg_c_enable => reg_c_en
        );

    u_datapath : gcd_datapath
        port map (
            clk          => clk,
            reset        => reset,
            AB           => AB,
            load_a       => load_a,
            load_b       => load_b,
            sub_a        => sub_a,
            sub_b        => sub_b,
            reg_c_enable => reg_c_en,
            a_equal_b    => a_eq_b,
            a_greater_b  => a_gt_b,
            C            => C
        );

end architecture structural;