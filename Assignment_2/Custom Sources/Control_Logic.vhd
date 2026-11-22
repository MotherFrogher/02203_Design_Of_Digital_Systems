library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.types.all;

entity Control_Logic is
    Port ( WCh_Cnt : out STD_LOGIC_VECTOR (1 downto 0);
           RCh_Cnt : out STD_LOGIC_VECTOR (1 downto 0);
           px_Sel : out STD_LOGIC_VECTOR (1 downto 0);
           clk : in STD_LOGIC;
           Addr : out STD_LOGIC_VECTOR(15 downto 0);
           W_Sel : out STD_LOGIC_VECTOR (1 downto 0);
           R_Sel : out STD_LOGIC_VECTOR (1 downto 0);
           R_en : out STD_LOGIC;
           W_en : out std_logic;
           X_Cnt : out std_logic_vector(7 downto 0);
           Y_Cnt : out std_logic_vector(8 downto 0);
           reset : in std_logic;
           start : in STD_LOGIC;
           finish : out STD_LOGIC);
end Control_Logic;

architecture Behavioral of Control_Logic is
type state_type is (IDLE, PRELOAD, PRE_WR, RUN, DRAIN, DONE);
--type state_type is 
signal state, next_state : state_type;

signal Rd_Cnt : unsigned(1 downto 0);
signal X_Cnt_u : unsigned(7 downto 0);
signal Y_Cnt_u : unsigned(8 downto 0);
signal RAddr_Cnt, WAddr_Cnt : std_logic_vector(15 downto 0);
signal RCh_Cnt_u, WCh_Cnt_u : unsigned(1 downto 0);
signal RAddr_Cnt_u, WAddr_Cnt_u : unsigned(15 downto 0);
signal RAddr_Cnt_u88, RAddr_Cnt_u176 : unsigned(15 downto 0);


signal R_active, W_active : std_logic;


constant X_MAX     : natural := 87;
constant Y_MAX     : natural := 287;
constant RADDR_MAX : natural := 25343;
constant WADDR_MAX : natural := 25343;

begin

RAddr_Cnt_u88 <= RAddr_Cnt_u + 88;
RAddr_Cnt_u176 <= RAddr_Cnt_u88 + 88;

--States
process(clk, reset)
begin
    if rising_edge(clk) then
        if reset = '1' then
            state <= IDLE;
        else
            state <= next_state;
        end if;
    end if;
end process;

--FSM
process(state, start, RCh_Cnt_u, WCh_Cnt_u, Rd_Cnt, RAddr_Cnt_u, X_Cnt_u, Y_Cnt_u)
begin
    next_state <= state;
    R_active <= '0';
    W_active <= '0';
    finish <= '0';
    
    case state is
        when IDLE =>
            if start = '1' then
                next_state <= PRELOAD;
            else
                next_state <= state;
            end if;
        
        when PRELOAD =>
            R_active <= '1';
            
            if RCh_Cnt_u = 3 and Rd_Cnt = "10" then
                next_state <= PRE_WR;
            else
                next_state <= state;
            end if;
        
        when PRE_WR =>
            R_active <= '1';
            W_active <= '1';
            
            if WCh_Cnt_u = 1 then
                next_state <= RUN;
            else
                next_state <= state;
            end if;
        
        when RUN =>
            if Rd_Cnt = 3 then
                W_active <= '1';
                R_active <= '1';
                if RAddr_Cnt_u = RADDR_MAX then
                    next_state <= DRAIN;
                end if;
            else
                next_state <= state;
                R_active <= '1';
            end if;
        
         when DRAIN =>
            W_active <= '1';
            R_active <= '1';
            
            
            if X_Cnt_u = X_MAX and Y_Cnt_u = Y_MAX then
                next_state <= DONE;
            else
                next_state <= state;
            end if;
         
         when DONE =>
            finish <= '1';
            next_state <= IDLE;
            
     end case;
end process;       
            
        


--Counters
READ_COUNTER: process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' or Rd_Cnt = "11" then
            Rd_Cnt <= "00";
        elsif State = PRELOAD and R_active = '1' then
            Rd_Cnt <= Rd_Cnt + 1;
                if Rd_Cnt = "10" then
                    Rd_Cnt <= "00";
                end if;
        elsif State = RUN and R_active = '1' then
            Rd_Cnt <= Rd_Cnt + 1;
        end if;
    end if;
end process;

Read_Chunk_Counter: process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            RCh_Cnt_u <= "00";
        elsif State = PRELOAD and Rd_Cnt = "10" and R_active = '1' then
            RCh_Cnt_u <= RCh_Cnt_u + 1;
        elsif Rd_Cnt = "11" and R_active = '1' then
            RCh_Cnt_u <= RCh_Cnt_u + 1;      -- 2 bits, wraps on its own
        end if;
    end if;
end process;

Write_Chunk_Counter: process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            WCh_Cnt_u <= "00";
        elsif W_active = '1' then
            WCh_Cnt_u <= WCh_Cnt_u + 1;
        end if;
    end if;
end process;    

X_COUNTER: process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            X_Cnt_u <= (others => '0');
        elsif W_active = '1' then
            if X_Cnt_u = X_MAX then
                X_Cnt_u <= (others => '0');
            else
                X_Cnt_u <= X_Cnt_u + 1;
            end if;
        end if;
    end if;
end process;

Y_COUNTER: process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            Y_Cnt_u <= (others => '0');
        elsif W_active = '1' and X_Cnt_u = X_MAX then   -- same edge X wraps
            if Y_Cnt_u = Y_MAX then
                Y_Cnt_u <= (others => '0');
            else
                Y_Cnt_u <= Y_Cnt_u + 1;
            end if;
        end if;
    end if;
end process;

Read_Address_Cnt: process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            RAddr_Cnt_u <= (others => '0');
        elsif state = PRELOAD and Rd_Cnt = "10" then
            if RAddr_Cnt_u = RADDR_MAX then
                RAddr_Cnt_u <= (others => '0');
            else
                RAddr_Cnt_u <= RAddr_Cnt_u + 1;
            end if;
        elsif state = RUN and Rd_Cnt = "11" then
            if RAddr_Cnt_u = RADDR_MAX then
                RAddr_Cnt_u <= (others => '0');
            else
                RAddr_Cnt_u <= RAddr_Cnt_u + 1;
            end if;
        end if;
    end if;
end process;

Write_Address_Counter: process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            WAddr_Cnt_u <= (others => '0');
        elsif W_active = '1' then
            if WAddr_Cnt_u = WADDR_MAX then
                WAddr_Cnt_u <= (others => '0');
            else
                WAddr_Cnt_u <= WAddr_Cnt_u + 1;
            end if;
        end if;
    end if;
end process;


--OUTPUT SIGNALS
X_Cnt <= std_logic_vector(X_Cnt_u);
Y_Cnt <= std_logic_vector(Y_Cnt_u);

Addr <= RAddr_Cnt when R_active = '1' and W_active = '0' else
        WAddr_Cnt when R_active = '1' and W_active = '1' else
        (others => '0');

RAddr_Cnt <= std_logic_vector(RAddr_Cnt_u) when Rd_Cnt = "00" else
             std_logic_vector(RAddr_Cnt_u88) when Rd_Cnt = "01" else
             std_logic_vector(RAddr_Cnt_u176) when Rd_Cnt = "10" else
             (others => '-');
             
WAddr_Cnt <= std_logic_vector(WAddr_Cnt_u + RADDR_MAX + 1);
RCh_Cnt    <= std_logic_vector(RCh_Cnt_u);
WCh_Cnt <= std_logic_vector(WCh_Cnt_u);

-- DISABLE IF PX MIRRORING WORKS
-- "11" = Discard all pixels, "10" = Discard left px
-- "01" = Discard right px, "00" = Discard no px.
--px_Sel <= "11" when (Y_Cnt_u <= 0 or Y_Cnt_u <= Y_MAX) else
--          "10" when X_Cnt_u <= 0 else
--         "01" when X_Cnt_u <= 87 else
--          "00";
px_Sel <= "00";
          
R_en <= R_active;

W_en <= W_active;

W_Sel <= "10" when W_active = '1' and WCh_Cnt_u = 1 and state = PRE_WR else
         "01";
         
-- "11" = Top row register, "10" = center row register, "01" = bottom row resigster
R_sel <= "11" when Rd_Cnt = 0 else
         "10" when Rd_Cnt = 1 else
         "01" when Rd_cnt = 2 else
         "00";

end Behavioral;