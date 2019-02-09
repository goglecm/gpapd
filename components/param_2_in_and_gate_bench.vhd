library work;
use work.gpapd_pack.all;

entity param_2_in_and_gate_bench is
    generic
    (
        WORD_LEN_DEGREE : integer := 6
    );
end entity;

architecture bench of param_2_in_and_gate_bench is
    component param_2_in_and_gate
    generic
    (
        WORD_LEN_DEGREE : integer
    );
    port
    (
        d0_in  : in  data_vector_t((2**WORD_LEN_DEGREE) - 1 downto 0);
        d1_in  : in  data_vector_t((2**WORD_LEN_DEGREE) - 1 downto 0);
        d0_out : out data_vector_t((2**WORD_LEN_DEGREE) - 1 downto 0)
    );
    end component param_2_in_and_gate;

    component param_2_in_and_gate_tb
    generic
    (
        WORD_LEN_DEGREE : integer
    );
    port
    (
        d0_out : out data_vector_t((2**WORD_LEN_DEGREE) - 1 downto 0);
        d1_out : out data_vector_t((2**WORD_LEN_DEGREE) - 1 downto 0);
        d0_in  : in  data_vector_t((2**WORD_LEN_DEGREE) - 1 downto 0)
    );
    end component param_2_in_and_gate_tb;

    signal d0_in_line  : data_vector_t((2**WORD_LEN_DEGREE) - 1 downto 0);
    signal d1_in_line  : data_vector_t((2**WORD_LEN_DEGREE) - 1 downto 0);
    signal d0_out_line : data_vector_t((2**WORD_LEN_DEGREE) - 1 downto 0);

begin

    comp : param_2_in_and_gate
        generic map
        (
            WORD_LEN_DEGREE => WORD_LEN_DEGREE
        )
        port map
        (
            d0_in => d0_in_line,
            d1_in => d1_in_line,
            d0_out => d0_out_line
        );

    tb : param_2_in_and_gate_tb
        generic map
        (
            WORD_LEN_DEGREE => WORD_LEN_DEGREE
        )
        port map
        (
            d0_out => d0_in_line,
            d1_out => d1_in_line,
            d0_in => d0_out_line
        );

end architecture bench;
