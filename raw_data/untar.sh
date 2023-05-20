#!/usr/bin/env bash

echo "Executing: cat poseidon-iperf3-data.tar.xz.part* > poseidon-iperf3-data.tar.xz"
cat poseidon-iperf3-data.tar.xz.part* > poseidon-iperf3-data.tar.xz

echo "Executing: tar -xf poseidon-iperf3-data.tar.xz"
tar -xf poseidon-iperf3-data.tar.xz
