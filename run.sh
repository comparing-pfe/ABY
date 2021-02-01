#!/usr/bin/env bash

exec build/bin/uc_circuit_test -c 1 -f ../UC/output/circuits/_Mod_SHDL.circuit_circ.txt -e ../UC/output/circuits/_Mod_SHDL.circuit_prog.txt -r $1 >> $2
