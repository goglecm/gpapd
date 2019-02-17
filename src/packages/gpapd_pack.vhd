library ieee;
use ieee.std_logic_1164.all;

package gpapd_pack is

    type data_bit_t is record
        t : std_ulogic;
        f : std_ulogic;
    end record data_bit_t;

    type data_vector_t is array (integer range <>) of data_bit_t;

    type ack_t is (ACK_EMPTY, ACK_VALID, ACK_INVALID);

    constant data_empty   : data_bit_t := (t => '0', f => '0');
    constant data_zero    : data_bit_t := (t => '0', f => '1');
    constant data_one     : data_bit_t := (t => '1', f => '0');
    constant data_invalid : data_bit_t := (t => '1', f => '1');

    constant TB : string := "testbench";
    constant FN : string := "module";

    constant TB_DELAY : time := 1 ns;
    constant TB_DELAY_ZERO : time := 0 ns;

    function to_str(d : data_bit_t) return string;
    function to_str(d : data_vector_t) return string;
    function and_op(a : data_bit_t; b : data_bit_t) return data_bit_t;

    procedure assert_eq(signal actual : data_bit_t; expected : data_bit_t);
    procedure assert_eq(signal actual : std_ulogic; expected : std_ulogic);
    procedure assert_eq(signal actual : ack_t; expected : ack_t);
    procedure assert_eq(signal data : data_vector_t; expected : data_bit_t);
    procedure assert_eq(signal data : data_vector_t; expected : data_vector_t);

    procedure assert_eq_var(actual : data_bit_t; expected : data_bit_t);

    procedure assert_neq(signal actual : data_bit_t; not_expected : data_bit_t);
    procedure assert_neq_var(actual : data_bit_t; not_expected : data_bit_t);

    function is_valid_var(data : data_bit_t) return boolean;

    function is_valid(signal data : data_bit_t) return boolean;
    function is_valid(signal d1 : data_bit_t; signal d2 : data_bit_t) return boolean;

    function is_empty_var(data : data_bit_t) return boolean;

    function is_empty(signal data : data_bit_t) return boolean;
    function is_empty(signal d1 : data_bit_t; signal d2 : data_bit_t) return boolean;

    procedure wait_until(signal data : data_bit_t; value : data_bit_t);
    procedure wait_until(signal data : ack_t; value : ack_t);
    procedure wait_until_is_valid(signal data : data_bit_t);
    procedure wait_until_is_valid(signal data : data_vector_t);
    procedure wait_until_is_empty(signal data : data_bit_t);
    procedure wait_until_is_empty(signal data : data_vector_t);

    procedure log(module_name : string; message : string);

    function invert_var(data : data_bit_t) return data_bit_t;

    procedure report_completion;

end gpapd_pack;

package body gpapd_pack is

    function to_str(d : data_bit_t) return string is
    begin
        return "t = " & std_ulogic'image(d.t) & ", f = " & std_ulogic'image(d.f);
    end to_str;

    function map_to_char(d : data_bit_t) return character is
    begin
        if (d = data_empty) then
            return 'E';
        elsif (d = data_zero) then
            return '0';
        elsif (d = data_one) then
            return '1';
        elsif (d = data_invalid) then
            return 'X';
        else
            return 'U';
        end if;
    end map_to_char;

    function to_str(d : data_vector_t) return string is
        variable pack_size     : integer := 32;
        variable sub_pack_size : integer := 8;
        variable unit_size     : integer := 3;
        variable result        : string(1 to (d'length * unit_size)     + -- Pretty data size of one unit
                                             (d'length / pack_size)     + -- New lines
                                             (d'length / sub_pack_size) + -- Spaces
                                             1);                          -- Last new line
        variable result_index  : integer := 1;
        variable data_index    : integer := d'length;
        variable data_value    : character;
    begin
        while data_index > 0 loop

            -- Insert spaces between numbers.
            if (data_index rem sub_pack_size) = 0 then
                result(result_index) := ' ';
                result_index := result_index + 1;
            end if;

            -- Insert new lines.
            if (data_index rem pack_size) = 0 then
                result(result_index) := LF;
                result_index := result_index + 1;
            end if;

            -- Data starts from 0 and goes up to d'length - 1.
            data_index := data_index - 1;

            -- Print the data_bit_t as a pretty character.
            data_value := map_to_char(d(data_index));

            -- Print the actual data_bit_t. This should match the unit_size.
            result(result_index + 0) := '(';
            result(result_index + 1) := data_value;
            result(result_index + 2) := ')';
            result_index := result_index + unit_size;

        end loop;

        -- Finally new line.
        result(result_index) := LF;

        return result;
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

    procedure assert_eq_var(actual : data_bit_t; expected : data_bit_t) is
    begin
        assert actual = expected
            report "Expected " & to_str(expected) & ", got " & to_str(actual)
                severity error;
    end procedure assert_eq_var;

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

    procedure assert_eq(signal data : data_vector_t; expected : data_bit_t) is
        variable actual_vector : data_vector_t(data'length - 1 downto 0) := data;
        variable expected_vector :
            data_vector_t(data'length - 1 downto 0) := (others => expected);
    begin
        assert actual_vector = expected_vector
            report "Expected " & to_str(expected_vector) &
                   ", got " & to_str(actual_vector)
                severity error;
    end procedure assert_eq;

    procedure assert_eq(signal data : data_vector_t; expected : data_vector_t) is
        variable actual_vector : data_vector_t(data'length - 1 downto 0) := data;
    begin
        assert actual_vector = expected
            report "Expected:" & to_str(expected) &
                   "Instead got:" & to_str(actual_vector)
                severity error;
    end procedure assert_eq;

    procedure assert_neq(signal actual : data_bit_t; not_expected : data_bit_t) is
    begin
        assert actual /= not_expected
            report "Unexpected" & to_str(actual)
                severity error;
    end procedure assert_neq;

    procedure assert_neq_var(actual : data_bit_t; not_expected : data_bit_t) is
    begin
        assert actual /= not_expected
            report "Unexpected" & to_str(actual)
                severity error;
    end procedure assert_neq_var;

    function is_valid(signal data : data_bit_t) return boolean is
    begin
        return (data = data_one) or (data = data_zero);
    end function is_valid;

    function is_valid_var(data : data_bit_t) return boolean is
    begin
        return (data = data_one) or (data = data_zero);
    end function is_valid_var;

    function is_valid(signal data : data_vector_t) return boolean is
        variable data_copy : data_vector_t(data'length - 1 downto 0) := data;
    begin
        for i in data_copy'length - 1 downto 0 loop
            if not is_valid_var(data_copy(i)) then
                return false;
            end if;
        end loop;

        return true;
    end function is_valid;

    function is_valid(signal d1 : data_bit_t; signal d2 : data_bit_t) return boolean is
    begin
        return is_valid(d1) and is_valid(d2);
    end function is_valid;

    function is_empty(signal data : data_bit_t) return boolean is
    begin
        return data = data_empty;
    end function is_empty;

    function is_empty_var(data : data_bit_t) return boolean is
    begin
        return data = data_empty;
    end function is_empty_var;

    function is_empty(signal data : data_vector_t) return boolean is
        variable all_zeros :
            data_vector_t(data'length - 1 downto 0) := (others => data_empty);
    begin
        return data = all_zeros;
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

    procedure wait_until_is_valid(signal data : data_bit_t) is
    begin
        if (not is_valid(data)) then
            wait until is_valid(data);
        end if;
    end procedure wait_until_is_valid;

    procedure wait_until_is_valid(signal data : data_vector_t) is
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

    procedure wait_until_is_empty(signal data : data_vector_t) is
    begin
        if (not is_empty(data)) then
            wait until is_empty(data);
        end if;
    end procedure wait_until_is_empty;

    procedure log(module_name : string; message : string) is
    begin
        report module_name & ": " & message severity note;
    end procedure log;

    function invert_var(data : data_bit_t) return data_bit_t is
    begin
        assert_neq_var(data, data_empty);
        assert_neq_var(data, data_invalid);

        if (data = data_one) then
            return data_zero;
        else
            return data_one;
        end if;
    end function invert_var;

    procedure report_completion is
    begin
        report "Test completed" severity note;
        wait;
    end procedure report_completion;

end gpapd_pack;
