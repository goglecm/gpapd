library work;
use work.gpapd_pack.all;

architecture bvl of async_and_gate is

    component and_gate
    port
    (
        a_in  : in  data_bit_t;
        b_in  : in  data_bit_t;
        c_out : out data_bit_t
    );
    end component and_gate;

    signal d0_in_line  : data_bit_t;
    signal d1_in_line  : data_bit_t;
    signal d0_out_line : data_bit_t;

begin

    d0_in_line <= d0_in;
    d1_in_line <= d1_in;
    d0_out     <= d0_out_line;

    func : and_gate port map
    (
        a_in  => d0_in_line,
        b_in  => d1_in_line,
        c_out => d0_out_line
    );

    main : process
    begin

        if (ack_in = ACK_EMPTY) then
            req_out <= REQ_VALID;
            wait_until_is_valid(d0_in_line);
            wait_until_is_valid(d1_in_line);
            wait_until(ack_in, ACK_VALID);
        elsif (ack_in = ACK_VALID) then
            req_out <= REQ_EMPTY;
            wait_until_is_empty(d0_in_line);
            wait_until_is_empty(d1_in_line);
            wait_until(ack_in, ACK_EMPTY);
        end if;

    end process main;

end architecture bvl;
