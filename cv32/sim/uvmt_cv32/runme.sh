#!/bin/bash
# Shell commands to compile assembler source for the CV32E40P testbench
# using the CV32E40P Board Support Package. 
# Assumes you are in $<wrk_cv32e40p>/cv32/sim/uvmt_cv32.
# Also generates a HEX file for verilog, a readelf and objdump,
# and greps out the Entry point address from the readelf (s.b. 0x80).

function assemble_me() {
  make clean-bsp
  make bsp

  /opt/riscv/bin/riscv32-unknown-elf-gcc -Os -g -static -mabi=ilp32 -march=rv32imc -Wall -pedantic \
	  -o ../../tests/core/custom/$1.elf \
	  -nostartfiles \
	  -I ../../tests/core/asm ../../tests/core/custom/$1.S \
	  -T ../../bsp/link.ld \
	  -L ../../bsp \
	  -lcv-verif

  /opt/riscv/bin/riscv32-unknown-elf-objcopy \
	  -O verilog \
	  ../../tests/core/custom/$1.elf \
	  ../../tests/core/custom/$1.hex

  /opt/riscv/bin/riscv32-unknown-elf-readelf \
	  -a \
	  ../../tests/core/custom/$1.elf > \
	  ../../tests/core/custom/$1.readelf

  /opt/riscv/bin/riscv32-unknown-elf-objdump \
	  -D \
	  ../../tests/core/custom/$1.elf > \
	  ../../tests/core/custom/$1.objdump
}

make clean_core_tests
ls -l ../../tests/core/custom
assemble_me riscv_ebreak_test_0
assemble_me riscv_arithmetic_basic_test_0
ls -l ../../tests/core/custom
grep -i entry ../../tests/core/custom/*.readelf

#end#end#