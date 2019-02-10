library gpapd_lib;
use gpapd_lib.gpapd_pack.all;

entity param_2_in_and_gate_tb is
    generic
    (
        WORD_LEN_DEGREE : natural
    );
	port
    (
        d0_out : out data_vector_t((2**WORD_LEN_DEGREE) - 1 downto 0);
        d1_out : out data_vector_t((2**WORD_LEN_DEGREE) - 1 downto 0);
        d0_in  : in  data_vector_t((2**WORD_LEN_DEGREE) - 1 downto 0)
    );
end entity param_2_in_and_gate_tb;

architecture test of param_2_in_and_gate_tb is
    signal d0_out_line : data_vector_t((2**WORD_LEN_DEGREE) - 1 downto 0);
    signal d1_out_line : data_vector_t((2**WORD_LEN_DEGREE) - 1 downto 0);
begin

    d0_out     <= d0_out_line;
    d1_out     <= d1_out_line;

    main : process
        variable flip : data_bit_t;
        variable expected : data_vector_t((2**WORD_LEN_DEGREE) - 1 downto 0);
    begin
        -- Perform AND on 010101... and 101010...
        -- Stage 1: clear
        d0_out_line <= (others => data_empty);
        d1_out_line <= (others => data_empty);
        wait for TB_DELAY;

        -- Stage 2: set outputs
        flip := data_zero;
        for i in 0 to (2**WORD_LEN_DEGREE) - 1 loop
            d0_out_line(i) <= flip;
            flip := invert_var(flip);
            d1_out_line(i) <= flip;
        end loop;
        wait for TB_DELAY;

        -- Stage 3: check inputs
        assert_eq(d0_in, data_zero);

        -- Perform AND on 010101... and 010101...
        -- Stage 1: clear
        d0_out_line <= (others => data_empty);
        d1_out_line <= (others => data_empty);
        wait for TB_DELAY;

        -- Stage 2: set outputs
        for i in 0 to (2**WORD_LEN_DEGREE) - 1 loop
            d0_out_line(i) <= flip;
            d1_out_line(i) <= flip;
            flip := invert_var(flip);
        end loop;
        wait for TB_DELAY;

        -- Stage 3: check inputs
        flip := data_zero;
        for i in 0 to (2**WORD_LEN_DEGREE) - 1 loop
            expected(i) := flip;
            flip := invert_var(flip);
        end loop;
        assert_eq(d0_in, expected);
        wait for TB_DELAY;

        report_completion;

    end process main;
end architecture;
