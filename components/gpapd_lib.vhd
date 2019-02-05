library ieee;
use ieee.std_logic_1164.all;

package gpapd_pack is

    -- generic (type element_type);

    type data_bit_t is record
        t : std_ulogic;
        f : std_ulogic;
    end record;

    constant data_empty   : data_bit_t := (t => '0', f => '0');
    constant data_zero    : data_bit_t := (t => '0', f => '1');
    constant data_one     : data_bit_t := (t => '1', f => '0');
    constant data_invalid : data_bit_t := (t => '1', f => '1');

    function to_str(d : data_bit_t) return string;
    function and_op(a : data_bit_t; b : data_bit_t) return data_bit_t;

    procedure assert_eq(actual : data_bit_t; expected : data_bit_t);

end gpapd_pack;

package body gpapd_pack is

    function to_str(d : data_bit_t) return string is
    begin
        return "t = " & std_ulogic'image(d.t) & ", f = " & std_ulogic'image(d.f);
    end to_str;

    function and_op(a : data_bit_t; b : data_bit_t) return data_bit_t is
    begin
        if (a = data_one) and (b = data_one) then
            return data_one;
        else
            return data_zero;
        end if;
    end and_op;

    procedure assert_eq(actual : data_bit_t; expected : data_bit_t) is
    begin
        assert actual = expected
            report "Expected " & to_str(expected) & ", got " & to_str(actual)
                severity error;
    end procedure assert_eq;

    procedure assert_eq(actual : std_ulogic; expected : std_ulogic) is
    begin
        assert actual = expected
            report "Expected " & std_ulogic'image(expected) &
                   ", got " & std_ulogic'image(actual)
                severity error;
    end procedure assert_eq;

end gpapd_pack;
