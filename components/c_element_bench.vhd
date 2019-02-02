library ieee;
use ieee.std_logic_1164.all;

---------------------------------------

entity c_element_bench is
end entity;

architecture bench of c_element_bench is

    component c_element
    port (
        a_in  : in  std_ulogic;
        b_in  : in  std_ulogic;
        c_out : out std_ulogic
    );
    end component c_element;

    component c_element_tb
    port (
        a_out : out std_ulogic;
        b_out : out std_ulogic;
        c_in  : in  std_ulogic
    );
    end component c_element_tb;

    signal a : std_ulogic;
    signal b : std_ulogic;
    signal c : std_ulogic;

begin

    comp : c_element port map
    (
        a_in  => a,
        b_in  => b,
        c_out => c
    );

    tb : c_element_tb port map
    (
        a_out => a,
        b_out => b,
        c_in  => c
    );

end architecture;
