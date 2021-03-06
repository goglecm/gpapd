library gpapd_lib;
use gpapd_lib.gpapd_pack.all;

entity async_and_gate is
    port
    (
        d0_in  : in  data_bit_t;
        d1_in  : in  data_bit_t;
        d0_out : out data_bit_t;
        ack_in : in ack_t
    );
end entity async_and_gate;
