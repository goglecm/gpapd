library work;
use work.gpapd_pack.all;

entity and_gate_tb is
    port
    (
        a_out  : out data_bit_t;
        b_out  : out data_bit_t;
        c_in : in  data_bit_t
    );
end entity and_gate_tb;

architecture test of and_gate_tb is
begin -- architecture test

    main : process

        -- Possible values for one input.
        type data_sequence_t is array (2 downto 0) of data_bit_t;
        variable data : data_sequence_t := (data_empty, data_zero, data_one);

        -- Function to calculate the output of an AND operation assuming the
        -- previous output state was data_empty.
        variable expected : data_bit_t;
        function get_expected(a : data_bit_t; b : data_bit_t)
        return data_bit_t is
        begin
            if (a /= data_empty) and (b /= data_empty) then
                return and_op(a, b);
            else
                return data_empty;
            end if;
        end function get_expected;

    begin -- main : process

        -- Cycle through all input combinations.
        for i in (data'length - 1) downto 0 loop
            for j in (data'length - 1) downto 0 loop

                expected := get_expected(data(i), data(j));

                -- Reset.
                a_out <= data_empty;
                b_out <= data_empty;
                wait for TB_DELAY;
                assert_eq(c_in, data_empty);

                -- Half way to valid.
                a_out <= data(i);
                wait for TB_DELAY;
                assert_eq(c_in, data_empty);

                -- Valid.
                b_out <= data(j);
                wait for TB_DELAY;
                assert_eq(c_in, expected);

                -- Half way to reset.
                a_out <= data_empty;
                wait for TB_DELAY;
                assert_eq(c_in, expected);

                -- Reset.
                b_out <= data_empty;
                wait for TB_DELAY;
                assert_eq(c_in, data_empty);

            end loop;
        end loop;

        report "Test completed" severity note;

    end process main;

end architecture test;
