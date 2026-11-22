
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity acc_tb is
end acc_tb;

architecture test of acc_tb is

    signal Px0, Px1, Px2, Px3, Px4,
           Px5, Px6, Px7, Px8 : unsigned(7 downto 0);

    signal output : unsigned(7 downto 0);

begin

    -- Instantiate the DUT
    DUT: entity work.acc
        port map (
            Px0 => Px0,
            Px1 => Px1,
            Px2 => Px2,
            Px3 => Px3,
            Px4 => Px4,
            Px5 => Px5,
            Px6 => Px6,
            Px7 => Px7,
            Px8 => Px8,
            output => output
        );

    -- Test process
    stim_proc: process

        procedure test_case(
            p0, p1, p2, p3, p4,
            p5, p6, p7, p8 : in natural
        ) is
            variable dx_exp : integer;
            variable dy_exp : integer;
            variable dn_exp : integer;
        begin

            -- Apply input values
            Px0 <= to_unsigned(p0, 8);
            Px1 <= to_unsigned(p1, 8);
            Px2 <= to_unsigned(p2, 8);
            Px3 <= to_unsigned(p3, 8);
            Px4 <= to_unsigned(p4, 8);
            Px5 <= to_unsigned(p5, 8);
            Px6 <= to_unsigned(p6, 8);
            Px7 <= to_unsigned(p7, 8);
            Px8 <= to_unsigned(p8, 8);

            wait for 10 ns;

            -- Calculate expected gradients
            dx_exp := p2 - p0 + 2*(p5 - p3) + p8 - p6;
            dy_exp := p0 - p6 + 2*(p1 - p7) + p2 - p8;

            -- Calculate expected output with saturation
            dn_exp := abs(dx_exp) + abs(dy_exp);

            if dn_exp > 255 then
                dn_exp := 255;
            end if;

            -- Compare DUT output with expected output
            assert to_integer(output) = dn_exp
                report "TEST FAILED! Expected: " &
                       integer'image(dn_exp) &
                       ", Got: " & integer'image(to_integer(output))
                severity error;

            report "Test passed. Output = " &
                   integer'image(to_integer(output))
                severity note;

        end procedure;

        variable seed : integer := 42;

    begin

        -- Test 1: All pixels black
        test_case(0,0,0,0,0,0,0,0,0);

        -- Test 2: All pixels white
        test_case(255,255,255,255,255,255,255,255,255);

        -- Test 3: Maximum positive Dx
        test_case(0,0,255,0,0,0,0,0,255);

        -- Test 4: Maximum negative Dx
        test_case(255,0,0,0,0,0,255,0,0);

        -- Test 5: Maximum positive Dy
        test_case(255,255,255,0,0,0,0,0,0);

        -- Test 6: Maximum negative Dy
        test_case(0,0,0,0,0,0,255,255,255);

        -- Test 7: Mixed pixel values
        test_case(10,50,200,100,128,240,30,180,220);

        -- Test 8: Random test cases
        for i in 1 to 100 loop

            seed := (seed * 73 + 19) mod 256;
            Px0 <= to_unsigned(seed, 8);

            seed := (seed * 73 + 19) mod 256;
            Px1 <= to_unsigned(seed, 8);

            seed := (seed * 73 + 19) mod 256;
            Px2 <= to_unsigned(seed, 8);

            seed := (seed * 73 + 19) mod 256;
            Px3 <= to_unsigned(seed, 8);

            seed := (seed * 73 + 19) mod 256;
            Px4 <= to_unsigned(seed, 8);

            seed := (seed * 73 + 19) mod 256;
            Px5 <= to_unsigned(seed, 8);

            seed := (seed * 73 + 19) mod 256;
            Px6 <= to_unsigned(seed, 8);

            seed := (seed * 73 + 19) mod 256;
            Px7 <= to_unsigned(seed, 8);

            seed := (seed * 73 + 19) mod 256;
            Px8 <= to_unsigned(seed, 8);

            wait for 10 ns;

            -- Calculate expected result
            test_case(
                to_integer(Px0),
                to_integer(Px1),
                to_integer(Px2),
                to_integer(Px3),
                to_integer(Px4),
                to_integer(Px5),
                to_integer(Px6),
                to_integer(Px7),
                to_integer(Px8)
            );

        end loop;

        report "ALL TESTS COMPLETED!" severity note;

        wait;

    end process;

end test;
