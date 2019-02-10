library gpapd_lib;
use gpapd_lib.gpapd_pack.all;

architecture bvl of and_gate is
    signal out_state : data_bit_t := data_empty;
begin

    c_out <= out_state;

    main : process(a_in, b_in)
    begin

        assert_neq(a_in, data_invalid);
        assert_neq(b_in, data_invalid);

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
