### BINS ###

HDL = ghdl
WAVEVIEWER = gtkwave

### END BINS ###

### PATHS ###

WORKDIR = work/
LIBDIR = libs/
SIMDIR = sim/

SRCCOMPONENTSDIR = src/components/
SRCPACKSDIR = src/packages/

### END PATHS ###

### SOURCES ###

LIBRARY_SRC = \
	$(SRCPACKSDIR)gpapd_pack.vhd

ENTITY_SRC = \
	$(SRCCOMPONENTSDIR)c_element_ent.vhd \
	$(SRCCOMPONENTSDIR)and_gate_ent.vhd \
	$(SRCCOMPONENTSDIR)param_2_in_and_gate_ent.vhd \
	$(SRCCOMPONENTSDIR)async_param_2_in_and_gate_ent.vhd \
	$(SRCCOMPONENTSDIR)async_and_gate_ent.vhd \

ARCH_SRC = \
	$(SRCCOMPONENTSDIR)c_element_arch_bvl.vhd \
	$(SRCCOMPONENTSDIR)and_gate_arch_bvl.vhd \
	$(SRCCOMPONENTSDIR)param_2_in_and_gate_arch_bvl.vhd \
	$(SRCCOMPONENTSDIR)async_param_2_in_and_gate_arch_bvl.vhd \
	$(SRCCOMPONENTSDIR)async_and_gate_arch_bvl.vhd \

TB_SRC = \
	$(SRCCOMPONENTSDIR)c_element_tb.vhd \
	$(SRCCOMPONENTSDIR)and_gate_tb.vhd \
	$(SRCCOMPONENTSDIR)param_2_in_and_gate_tb.vhd \
	$(SRCCOMPONENTSDIR)async_param_2_in_and_gate_tb.vhd \
	$(SRCCOMPONENTSDIR)async_and_gate_tb.vhd \

BENCH_SRC = \
	$(SRCCOMPONENTSDIR)c_element_bench.vhd \
	$(SRCCOMPONENTSDIR)and_gate_bench.vhd \
	$(SRCCOMPONENTSDIR)param_2_in_and_gate_bench.vhd \
	$(SRCCOMPONENTSDIR)async_param_2_in_and_gate_bench.vhd \
	$(SRCCOMPONENTSDIR)async_and_gate_bench.vhd \

ALL_SRC = \
	$(ENTITY_SRC) \
	$(ARCH_SRC) \
	$(TB_SRC) \
	$(BENCH_SRC) \

### END SOURCES ###

### FLAGS ###

ALL_WAVEVIEWER_FLAGS = \
	-c 8 \

HDL_LIBS_FLAGS = \
	--work=gpapd_lib \
	--workdir=$(LIBDIR) \

GENERAL_HDL_FLAGS = \
	-O3 \
	-g3 \

HDL_RUN_FLAGS = \
	--stop-delta=5000 \
	--stop-time=100ns \
	--assert-level=error \
	#--stats \
	#--disp-time

ANALYSIS_HDL_FLAGS = \
	--workdir=$(WORKDIR) \
	-P$(LIBDIR) \
	$(GENERAL_HDL_FLAGS) \
	#--std=02 \

### END FLAGS ###

### MISC ###
ALL_ENTITIES = \
	c_element_bench \
	and_gate_bench \
	param_2_in_and_gate_bench \
	async_param_2_in_and_gate_bench \
	async_and_gate_bench \

define \n


endef

### END MISC ###

.PHONY : clean all run prepare_libraries prepare_sources

### WAVEVIEWER TARGETS ###

c_element_bvl :
	# $(WAVEVIEWER) $(ALL_WAVEVIEWER_FLAGS) $(SIMDIR)$(C_ELEMENT_WAVE_FILE)

and_gate_bvl :
	# $(WAVEVIEWER) $(ALL_WAVEVIEWER_FLAGS) $(SIMDIR)$(AND_GATE_WAVE_FILE)

### LIBRARY TARGETS ###

import_libraries:
	$(foreach var,$(LIBRARY_SRC), $(HDL) -i $(HDL_LIBS_FLAGS) $(GENERAL_HDL_FLAGS) $(var);${\n})

check_libraries:
	$(foreach var,$(LIBRARY_SRC), $(HDL) -s $(HDL_LIBS_FLAGS) $(GENERAL_HDL_FLAGS) $(var);${\n})

analyse_libraries:
	$(foreach var,$(LIBRARY_SRC), $(HDL) -a $(HDL_LIBS_FLAGS) $(GENERAL_HDL_FLAGS) $(var);${\n})

prepare_libraries:
	make -j import_libraries
	make -j check_libraries
	make -j analyse_libraries

### SOURCE TARGETS ###

import_sources:
	$(foreach var,$(ALL_SRC), $(HDL) -i $(ANALYSIS_HDL_FLAGS) $(var);${\n})

check_sources:
	$(foreach var,$(ALL_SRC), $(HDL) -s $(ANALYSIS_HDL_FLAGS) $(var);${\n})

analyse_sources:
	$(foreach var,$(ALL_SRC), $(HDL) -a $(ANALYSIS_HDL_FLAGS) $(var);${\n})

prepare_sources:
	make -j import_sources
	make -j check_sources
	make -j analyse_sources

run:
	$(foreach var,$(ALL_ENTITIES), $(HDL) --elab-run $(ANALYSIS_HDL_FLAGS) $(var) $(HDL_RUN_FLAGS)--vcd=$(SIMDIR)$(var).vcd;${\n})

### CLEANUP TARGETS ###

clean_1 :
	rm -rf $(WORKDIR)*

clean_2 :
	rm -rf $(SIMDIR)*

clean_3 :
	rm -rf $(LIBDIR)*

clean : clean_1 clean_2 clean_3

### TOP TARGETS ###

main_target:
	make -j clean
	make prepare_libraries
	make prepare_sources
	make -j run

all :
	make main_target
