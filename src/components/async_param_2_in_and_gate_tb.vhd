library gpapd_lib;
use gpapd_lib.gpapd_pack.all;

entity async_param_2_in_and_gate_tb is
    generic
    (
        WORD_LEN_DEGREE : natural
    );
    port
    (
        d0_out  : out  data_vector_t(2**WORD_LEN_DEGREE - 1 downto 0);
        d1_out  : out  data_vector_t(2**WORD_LEN_DEGREE - 1 downto 0);
        d0_in   : in data_vector_t(2**WORD_LEN_DEGREE - 1 downto 0);
        ack_out : out ack_t
    );
end entity async_param_2_in_and_gate_tb;

architecture test of async_param_2_in_and_gate_tb is
begin

    main : process
    begin

        d0_out <= (others => data_one);
        wait for TB_DELAY;
        d1_out <= (others => data_zero);
        wait for TB_DELAY;
        wait_until_is_valid(d0_in);
        assert_eq(d0_in, data_zero);
        ack_out <= ACK_VALID;
        wait for TB_DELAY;

        d0_out <= (others => data_empty);
        wait for TB_DELAY;
        d1_out <= (others => data_empty);
        wait for TB_DELAY;
        wait_until_is_empty(d0_in);
        assert_eq(d0_in, data_empty);
        ack_out <= ACK_EMPTY;
        wait for TB_DELAY;

        d0_out <= (others => data_one);
        wait for TB_DELAY;
        d1_out <= (others => data_one);
        wait for TB_DELAY;
        wait_until_is_valid(d0_in);
        assert_eq(d0_in, data_one);
        ack_out <= ACK_VALID;
        wait for TB_DELAY;

        d0_out <= (others => data_empty);
        wait for TB_DELAY;
        d1_out <= (others => data_empty);
        wait for TB_DELAY;
        wait_until_is_empty(d0_in);
        assert_eq(d0_in, data_empty);
        ack_out <= ACK_EMPTY;
        wait for TB_DELAY;

        report_completion;

    end process main;

end architecture test;
