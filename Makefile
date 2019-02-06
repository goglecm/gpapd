define \n


endef

HDL = ghdl
WAVEVIEWER = gtkwave

WORKDIR = work/
SIMDIR = sim/
COMPONENTSDIR = components/

ALL_WAVEVIEWER_FLAGS = \
	-c 8 \

HDL_RUN_FLAGS = \
	--assert-level=error \
	--stop-delta=5000 \
	--stop-time=50ns \
	#--stats \
	#--disp-time

ALL_HDL_FLAGS = \
	#--std=02 \

LIBRARY_SRC = \
	$(COMPONENTSDIR)gpapd_lib.vhd

ENTITY_SRC = \
	$(COMPONENTSDIR)c_element_ent.vhd \
	$(COMPONENTSDIR)and_gate_ent.vhd \
	$(COMPONENTSDIR)async_and_gate_ent.vhd \

ARCH_SRC = \
	$(COMPONENTSDIR)c_element_arch_bvl.vhd \
	$(COMPONENTSDIR)and_gate_arch_bvl.vhd \
	$(COMPONENTSDIR)async_and_gate_arch_bvl.vhd \

TB_SRC = \
	$(COMPONENTSDIR)c_element_tb.vhd \
	$(COMPONENTSDIR)and_gate_tb.vhd \
	$(COMPONENTSDIR)async_and_gate_tb.vhd \

BENCH_SRC = \
	$(COMPONENTSDIR)c_element_bench.vhd \
	$(COMPONENTSDIR)and_gate_bench.vhd \
	$(COMPONENTSDIR)async_and_gate_bench.vhd \

ALL_SRC = \
	$(LIBRARY_SRC) \
	$(ENTITY_SRC) \
	$(ARCH_SRC) \
	$(TB_SRC) \
	$(BENCH_SRC) \

ALL_ENTITIES = \
	c_element_bench \
	and_gate_bench \
	async_and_gate_bench \

.PHONY : clean all c_element_bvl and_gate_bvl

c_element_bvl :
	# $(WAVEVIEWER) $(ALL_WAVEVIEWER_FLAGS) $(SIMDIR)$(C_ELEMENT_WAVE_FILE)

and_gate_bvl :
	# $(WAVEVIEWER) $(ALL_WAVEVIEWER_FLAGS) $(SIMDIR)$(AND_GATE_WAVE_FILE)

prepare:
	$(foreach var,$(ALL_SRC), $(HDL) -i --workdir=$(WORKDIR) $(ALL_HDL_FLAGS) $(var);${\n})
	$(foreach var,$(ALL_SRC), $(HDL) -s --workdir=$(WORKDIR) $(ALL_HDL_FLAGS) $(var);${\n})
	$(foreach var,$(ALL_SRC), $(HDL) -a --workdir=$(WORKDIR) $(ALL_HDL_FLAGS) $(var);${\n})
	$(foreach var,$(ALL_ENTITIES), $(HDL) -e --workdir=$(WORKDIR) $(ALL_HDL_FLAGS) $(var);${\n})
	$(foreach var,$(ALL_ENTITIES), $(HDL) -r --workdir=$(WORKDIR) $(var) $(HDL_RUN_FLAGS) --vcd=$(SIMDIR)$(var).vcd;${\n})

clean_1 :
	rm -rf $(WORKDIR)*

clean_2 :
	rm -rf $(SIMDIR)*

clean_all : clean_1 clean_2

all : clean_all prepare c_element_bvl and_gate_bvl
