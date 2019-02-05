library work;
use work.gpapd_pack.all;

---------------------------------------

entity and_gate_bench is
end entity;

architecture bench of and_gate_bench is

    component and_gate_tb
    port (
      a_out : out data_bit_t;
      b_out : out data_bit_t;
      c_in  : in  data_bit_t
    );
    end component and_gate_tb;

    component and_gate
    port (
      a_in  : in  data_bit_t;
      b_in  : in  data_bit_t;
      c_out : out data_bit_t
    );
    end component and_gate;

    signal aa : data_bit_t;
    signal bb : data_bit_t;
    signal cc : data_bit_t;

begin

    comp : and_gate port map
    (
        a_in  => aa,
        b_in  => bb,
        c_out => cc
    );

    tb : and_gate_tb port map
    (
        a_out => aa,
        b_out => bb,
        c_in  => cc
    );

end architecture;
