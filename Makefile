# Make file for digital system design final 2016

VLOG       := ncverilog

LIBDIR     := lib

SRCDIR     := src

RAMMODEL   := ./$(LIBDIR)/RAM2Kx32.v

MYSRC      := ./$(SRCDIR)/opcode.v \
			  ./$(SRCDIR)/constantunit.v \
			  ./$(SRCDIR)/dflipflop.v \
			  ./$(SRCDIR)/functionunit.v \
			  ./$(SRCDIR)/instdecoder.v \
			  ./$(SRCDIR)/instexecute.v \
			  ./$(SRCDIR)/instfetch.v \
			  ./$(SRCDIR)/mux32_21.v \
			  ./$(SRCDIR)/mux32_31.v \
			  ./$(SRCDIR)/mux32_41.v \
			  ./$(SRCDIR)/registerfile.v \
			  ./$(SRCDIR)/risc.v

PRESRC     := ./$(SRCDIR)/header.v \
			  ./$(SRCDIR)/testdata.v \
              ./$(SRCDIR)/risc_t.v \
              $(RAMMODEL)

SRC        := $(PRESRC) \
	          $(MYSRC)

SYNSRC     := ./$(SRCDIR)/syn.v \
              ./$(SRCDIR)/header.v \
              ./$(SRCDIR)/risc_t.v \
              $(RAMMODEL) \
			  /theda21_2/CBDK_IC_Contest/CBDK_IC_Contest_v2.1/Verilog/tsmc13.v

R          := 01

VLOGARG    := +access+r

EXVLOGARG  := +nospecify +notimingchecks

TMPFILE    := *.log \
              verilog.key \
              nWaveLog \
			  INCA_libs

DBFILE     := *.bak

RM         := rm -rf

.PHONY: clean

all : check

sim :
	$(VLOG) $(SRC) $(VLOGARG) +define+R$(R)

check :
	$(VLOG) $(SRC) $(VLOGARG) -c +define+R$(R)

syn :
	$(VLOG) $(SYNSRC) $(VLOGARG) +define+R$(R)

clean :
	-$(RM) $(DBFILE) $(TMPFILE)
