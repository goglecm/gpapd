library gpapd_lib;
use gpapd_lib.gpapd_pack.all;

entity async_param_2_in_and_gate_bench is
    generic
    (
        WORD_LEN_DEGREE : natural := 6
    );
end entity;

architecture bench of async_param_2_in_and_gate_bench is

    component async_param_2_in_and_gate_tb
    generic
    (
        WORD_LEN_DEGREE : natural
    );
    port
    (
        d0_out  : out  data_vector_t(2**WORD_LEN_DEGREE - 1 downto 0);
        d1_out  : out  data_vector_t(2**WORD_LEN_DEGREE - 1 downto 0);
        d0_in   : in data_vector_t(2**WORD_LEN_DEGREE - 1 downto 0);
        ack_out : out  ack_t
    );
    end component async_param_2_in_and_gate_tb;

    component async_param_2_in_and_gate
    generic
    (
        WORD_LEN_DEGREE : natural
    );
    port
    (
        d0_in   : in  data_vector_t(2**WORD_LEN_DEGREE - 1 downto 0);
        d1_in   : in  data_vector_t(2**WORD_LEN_DEGREE - 1 downto 0);
        d0_out  : out data_vector_t(2**WORD_LEN_DEGREE - 1 downto 0);
        ack_in  : in  ack_t
    );
    end component async_param_2_in_and_gate;

    signal d0_in_line   : data_vector_t(2**WORD_LEN_DEGREE - 1 downto 0);
    signal d1_in_line   : data_vector_t(2**WORD_LEN_DEGREE - 1 downto 0);
    signal d0_out_line  : data_vector_t(2**WORD_LEN_DEGREE - 1 downto 0);
    signal ack_in_line  : ack_t;

begin

    comp : async_param_2_in_and_gate
    generic map
    (
        WORD_LEN_DEGREE => WORD_LEN_DEGREE
    )
    port map
    (
        d0_in => d0_in_line,
        d1_in => d1_in_line,
        d0_out => d0_out_line,
        ack_in => ack_in_line
    );

    tb : async_param_2_in_and_gate_tb
    generic map
    (
        WORD_LEN_DEGREE => WORD_LEN_DEGREE
    )
    port map
    (
        d0_out => d0_in_line,
        d1_out => d1_in_line,
        d0_in => d0_out_line,
        ack_out => ack_in_line
    );

end architecture bench;
