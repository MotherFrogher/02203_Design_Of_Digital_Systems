----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.09.2026 10:38:35
-- Design Name: 
-- Module Name: Datapath - Behavioral
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
use ieee.numeric_std.all;

entity Datapath is
    Port (clk: in std_logic;
          AB: in unsigned(15 downto 0);
          ABorALU, LDA, LDB: in std_logic;
          FN: in std_logic_vector(1 downto 0);
          ALB, AGB, EQ: out std_logic;
          C: out unsigned(15 downto 0);
          N, Z: out std_logic
          );
end Datapath;

architecture Structural of Datapath is

component buf is
    generic (N:     natural := 16);				-- width of inputs.
    port (data_in_buf:  in  unsigned(N downto 1);	-- input.
          data_out_buf: out unsigned(N downto 1));	-- output.
end component buf;

component mux is
    generic (N:     natural := 16);				-- width of inputs and output.
    port (data_in1_mux:  in  unsigned(N downto 1);	-- inputs.
          data_in2_mux:  in unsigned(N downto 1);
          s       :  in std_logic;				-- select signal.
          data_out_mux:  out  unsigned(N downto 1)	-- output.
          );
end component mux;

component reg is
    generic (N:     natural := 16);				-- width of inputs.
    port (clk:      in  std_logic;				-- clock signal.
          en:       in  std_logic;				-- enable signal.
          data_in_reg:  in  unsigned(N downto 1);	-- input data.
          data_out_reg: out unsigned(N downto 1));	-- output data.
end component reg;

component alu is
    generic (W:     natural := 16);						-- width of inputs.
    port (A, B:     in unsigned(w downto 1);			-- input operands.
          fn:       in std_logic_vector(1 downto 0); 	-- function.
          Y:        out unsigned(W downto 1);			-- result.
          Z:        out std_logic;          			-- result = 0 flag.
          N:        out std_logic);         			-- result neg flag.
end component alu;

component Full_Comparator is
    Port(a, b: in unsigned(15 downto 0);
        AGB, ALB, EQ: out std_logic);
end component Full_Comparator;

signal C_int: unsigned(15 downto 0);
signal LDA_sig: unsigned(15 downto 0);
signal LDB_sig: unsigned(15 downto 0);
signal alu_sig: unsigned(15 downto 0);
begin

U1: mux port map(data_in1_mux => AB, data_in2_mux => alu_sig, s => ABorALU, data_out_mux => C_int);
U2: reg port map(data_in_reg => C_int, en => LDA, data_out_reg => LDA_sig, clk => clk);
U3: reg port map(data_in_reg => C_int, en => LDB, data_out_reg => LDB_sig, clk => clk);
U4: alu port map(A => LDA_sig, B => LDB_sig, fn => FN, Y => alu_sig, Z => Z, N => N);
U5: buf port map(data_in_buf => LDA_sig, data_out_buf => C);
U6: Full_Comparator port map (A => LDA_sig, B => LDB_sig, ALB => ALB, AGB => AGB, EQ => EQ);




end Structural;
