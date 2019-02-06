library work;
use work.gpapd_pack.all;

entity async_and_gate_tb is
    port
    (
        d0_out  : out  data_bit_t;
        d1_out  : out  data_bit_t;
        d0_in   : in data_bit_t;
        ack_out : out ack_t;
        req_in  : in req_t
    );
end entity;

architecture test of async_and_gate_tb is
begin

    main : process
    begin

        wait_until(req_in, REQ_VALID);
        wait for 1 ns;
        d0_out <= data_one;
        wait for 1 ns;
        d1_out <= data_zero;
        wait for 1 ns;
        wait_until_is_valid(d0_in);
        assert_eq(d0_in, data_zero);
        wait for 1 ns;
        ack_out <= ACK_VALID;

        wait_until(req_in, REQ_EMPTY);
        wait for 1 ns;
        d0_out <= data_empty;
        wait for 1 ns;
        d1_out <= data_empty;
        wait for 1 ns;
        wait_until_is_empty(d0_in);
        assert_eq(d0_in, data_empty);
        wait for 1 ns;
        ack_out <= ACK_EMPTY;

        wait_until(req_in, REQ_VALID);
        wait for 1 ns;
        d0_out <= data_one;
        wait for 1 ns;
        d1_out <= data_one;
        wait for 1 ns;
        wait_until_is_valid(d0_in);
        assert_eq(d0_in, data_one);
        wait for 1 ns;
        ack_out <= ACK_VALID;

        wait_until(req_in, REQ_EMPTY);
        wait for 1 ns;
        d0_out <= data_empty;
        wait for 1 ns;
        d1_out <= data_empty;
        wait for 1 ns;
        wait_until_is_empty(d0_in);
        assert_eq(d0_in, data_empty);
        wait for 1 ns;
        ack_out <= ACK_EMPTY;

        report "Test completed" severity note;

    end process main;

end architecture test;