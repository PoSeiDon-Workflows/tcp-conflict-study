#!/usr/bin/env bash

set_of_directories=("poseidon-sender-1/output" "poseidon-sender-2/output")
for i in ${set_of_directories[@]}; do
for dir_item in ${i}/*; do
  if [[ -d $dir_item ]]; then
    for file_item in $dir_item/iperf_*.out; do
      if [[ -f $file_item ]]; then
          #grep sender $file_item | cut -d ']' -f 2 | tail -n 1
          l=$(tail -n 1 $file_item)
          if [ "$l" != "iperf Done." ]; then
            echo $file_item
          fi
      fi
    done
  fi
done
done
