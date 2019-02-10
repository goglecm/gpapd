library gpapd_lib;
use gpapd_lib.gpapd_pack.all;

entity async_and_gate_bench is
end entity;

architecture bench of async_and_gate_bench is

    component async_and_gate_tb
    port
    (
        d0_out  : out data_bit_t;
        d1_out  : out data_bit_t;
        d0_in   : in  data_bit_t;
        ack_out : out ack_t;
        req_in  : in  req_t
    );
    end component async_and_gate_tb;

    component async_and_gate
    port
    (
        d0_in   : in  data_bit_t;
        d1_in   : in  data_bit_t;
        d0_out  : out data_bit_t;
        ack_in  : in  ack_t;
        req_out : out req_t
    );
    end component async_and_gate;

    signal d0_in_line   : data_bit_t;
    signal d1_in_line   : data_bit_t;
    signal d0_out_line  : data_bit_t;
    signal ack_in_line  : ack_t;
    signal req_out_line : req_t;

begin

    comp : async_and_gate port map
    (
        d0_in => d0_in_line,
        d1_in => d1_in_line,
        d0_out => d0_out_line,
        ack_in => ack_in_line,
        req_out => req_out_line
    );

    tb : async_and_gate_tb port map
    (
        d0_out => d0_in_line,
        d1_out => d1_in_line,
        d0_in => d0_out_line,
        ack_out => ack_in_line,
        req_in => req_out_line
    );

end architecture bench;
