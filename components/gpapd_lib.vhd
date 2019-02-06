library ieee;
use ieee.std_logic_1164.all;

package gpapd_pack is

    type data_bit_t is record
        t : std_ulogic;
        f : std_ulogic;
    end record data_bit_t;

    type ack_t is (ACK_EMPTY, ACK_VALID, ACK_INVALID);
    type req_t is (REQ_EMPTY, REQ_VALID, REQ_INVALID);

    constant data_empty   : data_bit_t := (t => '0', f => '0');
    constant data_zero    : data_bit_t := (t => '0', f => '1');
    constant data_one     : data_bit_t := (t => '1', f => '0');
    constant data_invalid : data_bit_t := (t => '1', f => '1');

    constant TB : string := "testbench";
    constant FN : string := "module";

    constant TB_DELAY : time := 1 ns;

    function to_str(d : data_bit_t) return string;
    function and_op(a : data_bit_t; b : data_bit_t) return data_bit_t;

    procedure assert_eq(signal actual : data_bit_t; expected : data_bit_t);
    procedure assert_eq(signal actual : std_ulogic; expected : std_ulogic);
    procedure assert_eq(signal actual : ack_t; expected : ack_t);
    procedure assert_eq(signal actual : req_t; expected : req_t);

    function is_valid(signal data : data_bit_t) return boolean;
    function is_valid(signal d1 : data_bit_t; signal d2 : data_bit_t) return boolean;
    function is_empty(signal data : data_bit_t) return boolean;
    function is_empty(signal d1 : data_bit_t; signal d2 : data_bit_t) return boolean;

    procedure wait_until(signal data : data_bit_t; value : data_bit_t);
    procedure wait_until(signal data : ack_t; value : ack_t);
    procedure wait_until(signal data : req_t; value : req_t);
    procedure wait_until_is_valid(signal data : data_bit_t);
    procedure wait_until_is_empty(signal data : data_bit_t);

    procedure log(module_name : string; message : string);

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

    procedure assert_eq(signal actual : data_bit_t; expected : data_bit_t) is
    begin
        assert actual = expected
            report "Expected " & to_str(expected) & ", got " & to_str(actual)
                severity error;
    end procedure assert_eq;

    procedure assert_eq(signal actual : std_ulogic; expected : std_ulogic) is
    begin
        assert actual = expected
            report "Expected " & std_ulogic'image(expected) &
                   ", got " & std_ulogic'image(actual)
                severity error;
    end procedure assert_eq;

    procedure assert_eq(signal actual : ack_t; expected : ack_t) is
    begin
        assert actual = expected
            report "Expected " & ack_t'image(expected) &
                   ", got " & ack_t'image(actual)
                severity error;
    end procedure assert_eq;

    procedure assert_eq(signal actual : req_t; expected : req_t) is
    begin
        assert actual = expected
            report "Expected " & req_t'image(expected) &
                   ", got " & req_t'image(actual)
                severity error;
    end procedure assert_eq;

    function is_valid(signal data : data_bit_t) return boolean is
    begin
        return (data = data_one) or (data = data_zero);
    end function is_valid;

    function is_valid(signal d1 : data_bit_t; signal d2 : data_bit_t) return boolean is
    begin
        return is_valid(d1) and is_valid(d2);
    end function is_valid;

    function is_empty(signal data : data_bit_t) return boolean is
    begin
        return data = data_empty;
    end function is_empty;

    function is_empty(signal d1 : data_bit_t; signal d2 : data_bit_t) return boolean is
    begin
        return is_empty(d1) and is_empty(d2);
    end function is_empty;

    procedure wait_until(signal data : data_bit_t; value : data_bit_t) is
    begin
        if (data /= value) then
            wait until data = value;
        end if;
    end procedure wait_until;

    procedure wait_until(signal data : ack_t; value : ack_t) is
    begin
        if (data /= value) then
            wait until data = value;
        end if;
    end procedure wait_until;

    procedure wait_until(signal data : req_t; value : req_t) is
    begin
        if (data /= value) then
            wait until data = value;
        end if;
    end procedure wait_until;

    procedure wait_until_is_valid(signal data : data_bit_t) is
    begin
        if (not is_valid(data)) then
            wait until is_valid(data);
        end if;
    end procedure wait_until_is_valid;

    procedure wait_until_is_empty(signal data : data_bit_t) is
    begin
        if (not is_empty(data)) then
            wait until is_empty(data);
        end if;
    end procedure wait_until_is_empty;

    procedure log(module_name : string; message : string) is
    begin
        report module_name & ": " & message severity note;
    end procedure log;

end gpapd_pack;
