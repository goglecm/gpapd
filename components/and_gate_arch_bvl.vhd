library work;
use work.gpapd_pack.all;

architecture bvl of and_gate is
    signal out_state : data_bit_t;
begin

    c_out <= out_state;

    main : process(a_in, b_in)
    begin

        assert a_in /= data_invalid
            report "Invalid data on input a"
                severity error;

        assert b_in /= data_invalid
            report "Invalid data on input b"
                severity error;

        if (a_in = data_one) and (b_in = data_one) and (out_state = data_empty) then
            out_state <= data_one;
        elsif (a_in = data_one) and (b_in = data_zero) and (out_state = data_empty) then
            out_state <= data_zero;
        elsif (a_in = data_zero) and (b_in = data_one) and (out_state = data_empty) then
            out_state <= data_zero;
        elsif (a_in = data_zero) and (b_in = data_zero) and (out_state = data_empty) then
            out_state <= data_zero;
        elsif (a_in = data_empty) and (b_in = data_empty) then
            out_state <= data_empty;
        end if;
    end process main;

end architecture bvl;
