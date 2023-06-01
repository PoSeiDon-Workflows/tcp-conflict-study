#!/usr/bin/env bash
bw=$1
cca1=$2
cca2=$3
aqm=$4
bdp=$5
run=$6
upper_limit_port=$(($7 + 10))
client=$8
flows=$9
mkdir -p output/${bw}_${cca1}_${cca2}_${aqm}_${bdp}_${run}
for i in $(seq 11 1 $upper_limit_port); do 
        $(iperf3 -c ${client} -p 156${i} -C ${cca1} -t 200 -f m -P ${flows} -M 8900 > output/${bw}_${cca1}_${cca2}_${aqm}_${bdp}_${run}/iperf_${i}.out 2>&1 &);
done
