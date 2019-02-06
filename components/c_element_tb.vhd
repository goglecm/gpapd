library ieee;
use ieee.std_logic_1164.all;

library work;
use work.gpapd_pack.all;

---------------------------------------

entity c_element_tb is
    port
    (
        a_out : out std_ulogic;
        b_out : out std_ulogic;
        c_in  : in  std_ulogic
    );
end entity c_element_tb;

architecture test of c_element_tb is
begin
    main : process
    begin
        a_out <= '0';
        b_out <= '0';
        wait for TB_DELAY;
        assert_eq(c_in, '0');

        a_out <= '1';
        b_out <= '0';
        wait for TB_DELAY;
        assert_eq(c_in, '0');

        a_out <= '0';
        b_out <= '1';
        wait for TB_DELAY;
        assert_eq(c_in, '0');

        a_out <= '1';
        b_out <= '1';
        wait for TB_DELAY;
        assert_eq(c_in, '1');

        a_out <= '1';
        b_out <= '0';
        wait for TB_DELAY;
        assert_eq(c_in, '1');

        a_out <= '0';
        b_out <= '1';
        wait for TB_DELAY;
        assert_eq(c_in, '1');

        a_out <= '0';
        b_out <= '0';
        wait for TB_DELAY;
        assert_eq(c_in, '0');

        report "Test completed" severity note;

    end process;
end architecture test;
