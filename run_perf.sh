#!/usr/bin/env bash

# Run this script in the project root
# Assumes a UC compiler present in the parent directory

# This script can be used to automatically run experiments for
# multiple numbers of gates (10 iterations each)

ITERATIONS=10

# r=$1

# if [ -n "$r" ] && [ "$r" -ge 0 ] && [ "$r" -le 1 ]
# then
# 	echo "r = $r"
# else
#         echo -e "Error: Missing argument.\n"
#         echo "Usage:"
#         echo "- Run the server: ./run_perf.sh 0"
#         echo "- Run the client: ./run_perf.sh 1"
# 	exit
# fi

server_fileprefix="perf_`date +'%Y-%m-%d-%H%M'`_SERVER_"
client_fileprefix="perf_`date +'%Y-%m-%d-%H%M'`_CLIENT_"

for g in 100 1000 10000 100000
do
	echo "Running with g = $g gates"

        # if [ "$r" -eq 0 ]; then
        # Generate circuit
        echo "Generating UC"
        pushd ../UC
        build/UC -random $g
        popd
        echo "Finished generating"
        # fi


	for i in $(seq $ITERATIONS)
	do
                # edit the next line to run on a different servers
                # example: bin/millionaire_prob_test -r $r -g $g -a 10.10.10.10 >> $fileprefix$g
		# build/UC -random $g >> $fileprefix$g
                # build/bin/uc_circuit_test -f ../UC/output/circuits/_Mod_SHDL.circuit_circ.txt -e ../UC/output/circuits/_Mod_SHDL.circuit_prog.txt -r $r >> $fileprefix$g
		# bin/millionaire_prob_test -r $r -g $g >> $fileprefix$g

                # Run server
                build/run.sh 0 $server_fileprefix$g &
                server_pid=$!

                # Run client
                build/run.sh 1 $client_fileprefix$g &
                client_pid=$!

                wait $server_pid
                wait $client_pid
		echo -n "[$i] "
	done
	echo ""

	# parsing performance outputs
	# time_total=`cat $fileprefix$g | grep Total\ = | awk '{ sum += $3} END { print sum/10}'`
	# echo "Runtime (averaged): $time_total"

done
