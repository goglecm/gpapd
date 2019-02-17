library gpapd_lib;
use gpapd_lib.gpapd_pack.all;

entity async_param_2_in_and_gate is
    generic
    (
        WORD_LEN_DEGREE : natural
    );
	port
    (
        d0_in  : in  data_vector_t(2**WORD_LEN_DEGREE - 1 downto 0);
        d1_in  : in  data_vector_t(2**WORD_LEN_DEGREE - 1 downto 0);
        d0_out : out data_vector_t(2**WORD_LEN_DEGREE - 1 downto 0);
        ack_in : in ack_t
    );
end entity async_param_2_in_and_gate;
