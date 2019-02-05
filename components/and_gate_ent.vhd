library work;
use work.gpapd_pack.all;

entity and_gate is
    port
    (
        a_in  : in  data_bit_t;
        b_in  : in  data_bit_t;
        c_out : out data_bit_t
    );
end entity and_gate;
