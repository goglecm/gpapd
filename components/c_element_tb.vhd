library ieee;
use ieee.std_logic_1164.all;

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
        constant DELAY : time := 1 ns;
    begin
        a_out <= '0';
        b_out <= '0';
        wait for DELAY;
        assert c_in = '0'
            report "Expected 0, got " & std_ulogic'image(c_in)
            severity error;

        a_out <= '1';
        b_out <= '0';
        wait for DELAY;
        assert c_in = '0'
            report "Expected 0, got " & std_ulogic'image(c_in)
            severity error;

        a_out <= '0';
        b_out <= '1';
        wait for DELAY;
        assert c_in = '0'
            report "Expected 0, got " & std_ulogic'image(c_in)
            severity error;

        a_out <= '1';
        b_out <= '1';
        wait for DELAY;
        assert c_in = '1'
            report "Expected 1, got " & std_ulogic'image(c_in)
            severity error;

        a_out <= '1';
        b_out <= '0';
        wait for DELAY;
        assert c_in = '1'
            report "Expected 1, got " & std_ulogic'image(c_in)
            severity error;

        a_out <= '0';
        b_out <= '1';
        wait for DELAY;
        assert c_in = '1'
            report "Expected 1, got " & std_ulogic'image(c_in)
            severity error;

        a_out <= '0';
        b_out <= '0';
        wait for DELAY;
        assert c_in = '0'
            report "Expected 0, got " & std_ulogic'image(c_in)
            severity error;

        report "Test completed" severity note;

    end process;
end architecture test;
