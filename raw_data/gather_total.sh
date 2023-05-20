#!/usr/bin/env bash

set_of_directories=("poseidon-sender-1/output" "poseidon-sender-2/output")
for i in ${set_of_directories[@]}; do
for dir_item in ${i}/*; do
  if [[ -d $dir_item ]]; then
    cat /dev/null > totals.out
    #echo $dir_item
    for file_item in $dir_item/iperf_*.out; do
      if [[ -f $file_item ]]; then
          #grep sender $file_item | cut -d ']' -f 2 | tail -n 1
          grep sender $file_item | cut -d ']' -f 2 | tail -n 1 >> totals.out
      fi
    done
    #paste -sd+ sums.out | bc
    #awk -F' ' '{sum1+=$5;sum2+=$7} END{printf "#goodput,retransmits\n%.2f,%d\n",sum1,sum2;}' totals.out
    awk -F' ' '{sum1+=$5;sum2+=$7} END{printf "#goodput,retransmits\n%.2f,%d\n",sum1,sum2;}' totals.out > ${dir_item}.total
  fi
done
done
rm totals.out
