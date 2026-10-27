-- -----------------------------------------------------------------------------
--
--  Title      :  Edge-Detection design project - task 2.
--             :
--  Developers :  YOUR NAME HERE - s??????@student.dtu.dk
--             :  YOUR NAME HERE - s??????@student.dtu.dk
--             :
--  Purpose    :  This design contains an entity for the accelerator that must be build
--             :  in task two of the Edge Detection design project. It contains an
--             :  architecture skeleton for the entity as well.
--             :
--  Revision   :  1.0   ??-??-??     Final version
--             :
--
-- -----------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- The entity for task two. Notice the additional signals for the memory.
-- reset is active high.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.types.all;

entity acc is
    port(
        clk    : in  bit_t;             -- The clock.
        reset  : in  bit_t;             -- The reset signal. Active high.
        addr   : out halfword_t;        -- Address bus for data.
        dataR  : in  word_t;            -- The data bus.
        dataW  : out word_t;            -- The data bus.
        en     : out bit_t;             -- Request signal for data.
        we     : out bit_t;             -- Read/Write signal for data.
        start  : in  bit_t;
        finish : out bit_t
    );
end acc;

--------------------------------------------------------------------------------
-- The desription of the accelerator.
--------------------------------------------------------------------------------

architecture rtl of acc is

-- All internal signals are defined here
    type state_type is (
    IDLE,
    READ,
    BUFF,
    WRITE,
    DONE
    );
    
signal current_state, next_state : state_type;
signal data_reg:                   word_t;
signal read_addr_reg:              unsigned(15 downto 0);
constant Max_word:                 unsigned(15 downto 0) := to_unsigned(25344, 16);
constant mem_offset:               unsigned(15 downto 0):= to_unsigned(25344, 16);

begin

-- Template for a process
       process(clk, reset)
         begin
           if rising_edge(clk) then
                if reset = '1' then
                    current_state <= IDLE;
                 else
                    current_state <= next_state;
            end if;
        end if;
   end process;

process(current_state, start)
    begin
    en            <= '0';
    we            <= '0';
    finish        <= '0';
    dataW         <= x"00000000";
    addr          <= x"0000";
    read_addr_reg <= x"0000";
    
    
case current_state is
    
   when IDLE =>
     if start = '1' then
       next_state <= READ;      
     else
        next_state <= IDLE;
     end if;
    
    
    
   when READ =>
         en     <= '1';
         addr   <= std_logic_vector(read_addr_reg);
     next_state <= BUFF;
    
    
    
   when BUFF =>
        data_reg     <= dataR;
        en           <= '1';
        addr         <= std_logic_vector(read_addr_reg + mem_offset);
     next_state   <= Write;
    
    
    
   when WRITE =>
       en    <= '1';
       we    <= '1';
       addr  <= std_logic_vector(read_addr_reg + mem_offset);
       dataW <= NOT data_reg;
       
   if read_addr_reg = Max_word-1 then    
       next_state  <= DONE;
     else 
         read_addr_reg <= read_addr_reg +1;
       next_state    <= WRITE;
   end if;
    
       
   when DONE =>
        en         <= '0';
        we         <= '0';
        finish     <= '1';
     next_state <= IDLE;  
   
   end case;     
 end process; 
end rtl;
