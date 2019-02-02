HDL = ghdl
WAVEVIEWER = gtkwave

WORKDIR = work/
SIMDIR = sim/
COMPONENTSDIR = components/

ALL_WAVEVIEWER_FLAGS = \
	-c 8

ALL_HDL_FLAGS = \
	--assert-level=error \
	--disp-time \
	--stats \
	--stop-delta=5000 \
	--stop-time=100ns

C_ELEMENT_SRC = \
	$(COMPONENTSDIR)c_element_ent.vhd \
	$(COMPONENTSDIR)c_element_arch_bvl.vhd \
	$(COMPONENTSDIR)c_element_tb.vhd \
	$(COMPONENTSDIR)c_element_bench.vhd

C_ELEMENT_TOP_ENTITY = c_element_bench
C_ELEMENT_WAVE_FILE = c_element_arch_bvl.vcd

.PHONY : clean all c_element_bvl

c_element_bvl :
	$(HDL) -a --workdir=$(WORKDIR) $(C_ELEMENT_SRC)
	$(HDL) -e --workdir=$(WORKDIR) $(C_ELEMENT_TOP_ENTITY)
	$(HDL) -r --workdir=$(WORKDIR) $(C_ELEMENT_TOP_ENTITY) $(ALL_HDL_FLAGS) --vcd=$(SIMDIR)$(C_ELEMENT_WAVE_FILE)
	$(WAVEVIEWER) $(ALL_WAVEVIEWER_FLAGS) $(SIMDIR)c_element_arch_bvl.vcd

clean :
	rm -rf $(WORKDIR)**
	rm -rf $(SIMDIR)**

all : c_element_bvl
