library gpapd_lib;
use gpapd_lib.gpapd_pack.all;

architecture bvl of param_2_in_and_gate is

    component and_gate
    port
    (
        a_in  : in  data_bit_t;
        b_in  : in  data_bit_t;
        c_out : out data_bit_t
    );
    end component and_gate;

begin

    gate_array : for gate_num in 0 to 2**WORD_LEN_DEGREE - 1 generate
        single : and_gate port map
        (
            a_in => d0_in(gate_num),
            b_in => d1_in(gate_num),
            c_out => d0_out(gate_num)
        );
    end generate gate_array;

end architecture bvl;
