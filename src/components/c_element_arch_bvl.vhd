library ieee;
use ieee.std_logic_1164.all;

architecture bvl of c_element is
begin
    main : process(a_in, b_in)
    begin
        if (a_in = '0') and (b_in = '0') then
            c_out <= '0';
        elsif (a_in = '1') and (b_in = '1') then
            c_out <= '1';
        end if;
    end process main;
end architecture bvl;
