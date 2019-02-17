library gpapd_lib;
use gpapd_lib.gpapd_pack.all;

architecture bvl of async_param_2_in_and_gate is

    component param_2_in_and_gate
    generic
    (
        WORD_LEN_DEGREE : natural
    );
    port (
        d0_in  : in  data_vector_t((2**WORD_LEN_DEGREE) - 1 downto 0);
        d1_in  : in  data_vector_t((2**WORD_LEN_DEGREE) - 1 downto 0);
        d0_out : out data_vector_t((2**WORD_LEN_DEGREE) - 1 downto 0)
    );
    end component param_2_in_and_gate;

    signal d0_in_line  : data_vector_t((2**WORD_LEN_DEGREE) - 1 downto 0);
    signal d1_in_line  : data_vector_t((2**WORD_LEN_DEGREE) - 1 downto 0);
    signal d0_out_line : data_vector_t((2**WORD_LEN_DEGREE) - 1 downto 0);

begin

    d0_in_line <= d0_in;
    d1_in_line <= d1_in;
    d0_out <= d0_out_line;

    func : param_2_in_and_gate
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

    main : process
    begin

        if (ack_in = ACK_EMPTY) then
            wait_until_is_valid(d0_in_line);
            wait_until_is_valid(d1_in_line);
            wait_until(ack_in, ACK_VALID);
        elsif (ack_in = ACK_VALID) then
            wait_until_is_empty(d0_in_line);
            wait_until_is_empty(d1_in_line);
            wait_until(ack_in, ACK_EMPTY);
        end if;

    end process main;

end architecture bvl;
