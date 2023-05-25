#!/usr/bin/env bash

#./raw_data/gather_totals.sh
./parser.py

for i in $(find . -name *.dat); do
for j in {1..10}; do
  sed -i 's/,0\.0,/,0\.0001,/g' $i
done
done


cwd=`pwd`
aqms=("fifo" "fq_codel" "red" "red_noecn")
bws=("100mbps" "500mbps" "1gbps" "10gbps" "25gbps")

for j in parsed_data_plots/*; do
if [[ -d $j ]]; then

i=${j#*/}

echo "$i - ${i%_*} - ${i#*_}"
alg1=${i%_*}
alg2=${i#*_}

cd ${cwd}/${j}
    
for aqm in ${aqms[@]}; do


filename="throughput_retx_${alg1}_${alg2}_${aqm}_boxes.pdf"
echo $filename
gnuplot<<EOC
    reset
    set terminal pdf size 10,12 font "Calibri, 26"
    set output "$filename"
    set datafile separator ","

    set multiplot layout 2,1 columns
    set style data histogram
    set style fill solid 1 border -1
    set style histogram clustered gap 2
    set boxwidth 0.9
    
    #set title "${alg1} vs ${alg2} - ${aqm}" noenhanced
    set notitle
    
    set ylabel "Throughput Mbps (log)"
    set logscale y
    #set xlabel "BDP Configuration"
    unset xlabel
    set key above vertical maxrows 4 right font "Calibri, 22"
    
    plot "${alg1}_${alg2}_${aqm}_100mbps.dat" using 2:xtic(1) title "100Mbps(1 ${alg1})" ls 1,\
         "${alg1}_${alg2}_${aqm}_100mbps.dat" using 3:xtic(1) title "100Mbps(1 ${alg2})" fillstyle pattern 1 ls 1,\
         "${alg1}_${alg2}_${aqm}_500mbps.dat" using 2:xtic(1) title "500Mbps(5 ${alg1})" ls 2,\
         "${alg1}_${alg2}_${aqm}_500mbps.dat" using 3:xtic(1) title "500Mbps(5 ${alg2})" fillstyle pattern 1 ls 2,\
         "${alg1}_${alg2}_${aqm}_1gbps.dat" using 2:xtic(1) title "1Gbps(10 ${alg1})" ls 3,\
         "${alg1}_${alg2}_${aqm}_1gbps.dat" using 3:xtic(1) title "1Gbps(10 ${alg2})" fillstyle pattern 1 ls 3,\
         "${alg1}_${alg2}_${aqm}_10gbps.dat" using 2:xtic(1) title "10Gbps(100 ${alg1})" ls 4,\
         "${alg1}_${alg2}_${aqm}_10gbps.dat" using 3:xtic(1) title "10Gbps(100 ${alg2})" fillstyle pattern 1 ls 4,\
         "${alg1}_${alg2}_${aqm}_25gbps.dat" using 2:xtic(1) title "25Gbps(250 ${alg1})" ls 5,\
         "${alg1}_${alg2}_${aqm}_25gbps.dat" using 3:xtic(1) title "25Gbps(250 ${alg2})" fillstyle pattern 1 ls 5

    
    set ylabel "reTX Packets (log)"
    set logscale y
    set xlabel "BDP Configuration"
    unset key
    
    plot "${alg1}_${alg2}_${aqm}_100mbps.dat" using 4:xtic(1) title "100Mbps(1 ${alg1})" ls 1,\
         "${alg1}_${alg2}_${aqm}_100mbps.dat" using 5:xtic(1) title "100Mbps(1 ${alg2})" fillstyle pattern 1 ls 1,\
         "${alg1}_${alg2}_${aqm}_500mbps.dat" using 4:xtic(1) title "500Mbps(5 ${alg1})" ls 2,\
         "${alg1}_${alg2}_${aqm}_500mbps.dat" using 5:xtic(1) title "500Mbps(5 ${alg2})" fillstyle pattern 1 ls 2,\
         "${alg1}_${alg2}_${aqm}_1gbps.dat" using 4:xtic(1) title "1Gbps(10 ${alg1})" ls 3,\
         "${alg1}_${alg2}_${aqm}_1gbps.dat" using 5:xtic(1) title "1Gbps(10 ${alg2})" fillstyle pattern 1 ls 3,\
         "${alg1}_${alg2}_${aqm}_10gbps.dat" using 4:xtic(1) title "10Gbps(100 ${alg1})" ls 4,\
         "${alg1}_${alg2}_${aqm}_10gbps.dat" using 5:xtic(1) title "10Gbps(100 ${alg2})" fillstyle pattern 1 ls 4,\
         "${alg1}_${alg2}_${aqm}_25gbps.dat" using 4:xtic(1) title "25Gbps(250 ${alg1})" ls 5,\
         "${alg1}_${alg2}_${aqm}_25gbps.dat" using 5:xtic(1) title "25Gbps(250 ${alg2})" fillstyle pattern 1 ls 5
EOC


filename="fairness_${alg1}_${alg2}_${aqm}_boxes.pdf"
echo $filename
gnuplot<<EOC
    reset
    set terminal pdf size 16,10 font "Calibri, 26"
    set output "$filename"
    set datafile separator ","

    set style data histogram
    set style fill solid 1 border -1
    set style histogram clustered gap 2
    set boxwidth 0.9
    
    #set title "Fairness: ${alg1} vs ${alg2} - ${aqm}" noenhanced
    set notitle
    
    set yrange [0:]
    set ylabel "Fairness Index"
    set xlabel "BDP Configuration"
    set key above horizontal right font "Calibri, 22"
    
    plot "${alg1}_${alg2}_${aqm}_100mbps.dat" using 6:xtic(1) title "100Mbps" ls 1,\
         "${alg1}_${alg2}_${aqm}_500mbps.dat" using 6:xtic(1) title "500Mbps" ls 2,\
         "${alg1}_${alg2}_${aqm}_1gbps.dat" using 6:xtic(1) title "1Gbps" ls 3,\
         "${alg1}_${alg2}_${aqm}_10gbps.dat" using 6:xtic(1) title "10Gbps" ls 4,\
         "${alg1}_${alg2}_${aqm}_25gbps.dat" using 6:xtic(1) title "25Gbps" ls 5
EOC

#########################################################

filename="throughput_retx_${alg1}_${alg2}_${aqm}_lines.pdf"
echo $filename
gnuplot<<EOC
    reset
    set terminal pdf size 10,12 font "Calibri, 26"
    set output "$filename"
    set datafile separator ","

    set multiplot layout 2,1 columns
    
    #set title "${alg1} vs ${alg2} - ${aqm}" noenhanced
    set notitle
    
    set ylabel "Throughput Mbps (log)"
    set logscale y
    unset xlabel
    set key above vertical maxrows 4 right font "Calibri, 22"
    
    plot "${alg1}_${alg2}_${aqm}_100mbps.dat" using 2:xtic(1) title "100Mbps(1 ${alg1})" with linespoints lw 5 pt 1,\
         "${alg1}_${alg2}_${aqm}_100mbps.dat" using 3:xtic(1) title "100Mbps(1 ${alg2})" with linespoints lw 5 pt 1,\
         "${alg1}_${alg2}_${aqm}_500mbps.dat" using 2:xtic(1) title "500Mbps(5 ${alg1})" with linespoints lw 5 pt 3,\
         "${alg1}_${alg2}_${aqm}_500mbps.dat" using 3:xtic(1) title "500Mbps(5 ${alg2})" with linespoints lw 5 pt 3,\
         "${alg1}_${alg2}_${aqm}_1gbps.dat" using 2:xtic(1) title "1Gbps(10 ${alg1})" with linespoints lw 5 pt 5,\
         "${alg1}_${alg2}_${aqm}_1gbps.dat" using 3:xtic(1) title "1Gbps(10 ${alg2})" with linespoints lw 5 pt 5,\
         "${alg1}_${alg2}_${aqm}_10gbps.dat" using 2:xtic(1) title "10Gbps(100 ${alg1})" with linespoints lw 5 pt 7,\
         "${alg1}_${alg2}_${aqm}_10gbps.dat" using 3:xtic(1) title "10Gbps(100 ${alg2})" with linespoints lw 5 pt 7,\
         "${alg1}_${alg2}_${aqm}_25gbps.dat" using 2:xtic(1) title "25Gbps(250 ${alg1})" with linespoints lw 5 pt 9,\
         "${alg1}_${alg2}_${aqm}_25gbps.dat" using 3:xtic(1) title "25Gbps(250 ${alg2})" with linespoints lw 5 pt 9
    
    
    set ylabel "reTX Packets (log)"
    set xlabel "BDP Configuration"
    unset key
    
    plot "${alg1}_${alg2}_${aqm}_100mbps.dat" using 4:xtic(1) title "100Mbps(1 ${alg1})" with linespoints lw 5 pt 1,\
         "${alg1}_${alg2}_${aqm}_100mbps.dat" using 5:xtic(1) title "100Mbps(1 ${alg2})" with linespoints lw 5 pt 1,\
         "${alg1}_${alg2}_${aqm}_500mbps.dat" using 4:xtic(1) title "500Mbps(5 ${alg1})" with linespoints lw 5 pt 3,\
         "${alg1}_${alg2}_${aqm}_500mbps.dat" using 5:xtic(1) title "500Mbps(5 ${alg2})" with linespoints lw 5 pt 3,\
         "${alg1}_${alg2}_${aqm}_1gbps.dat" using 4:xtic(1) title "1Gbps(10 ${alg1})" with linespoints lw 5 pt 5,\
         "${alg1}_${alg2}_${aqm}_1gbps.dat" using 5:xtic(1) title "1Gbps(10 ${alg2})" with linespoints lw 5 pt 5,\
         "${alg1}_${alg2}_${aqm}_10gbps.dat" using 4:xtic(1) title "10Gbps(100 ${alg1})" with linespoints lw 5 pt 7,\
         "${alg1}_${alg2}_${aqm}_10gbps.dat" using 5:xtic(1) title "10Gbps(100 ${alg2})" with linespoints lw 5 pt 7,\
         "${alg1}_${alg2}_${aqm}_25gbps.dat" using 4:xtic(1) title "25Gbps(250 ${alg1})" with linespoints lw 5 pt 9,\
         "${alg1}_${alg2}_${aqm}_25gbps.dat" using 5:xtic(1) title "25Gbps(250 ${alg2})" with linespoints lw 5 pt 9
EOC

filename="throughput_${alg1}_${alg2}_${aqm}_detailed.pdf"
echo $filename
gnuplot<<EOC
    reset
    set terminal pdf size 10,12 font "Calibri, 22"
    set output "$filename"
    set datafile separator ","

    set multiplot layout 3,2 columns
    
    
    set ylabel "Throughput Mbps"
#    set logscale y
    unset xlabel
    #set xlabel "BDP Configuration"
    set key top right font "Calibri, 18"
    
    set title "100Mbps (1 vs 1 flows)" noenhanced
    plot "${alg1}_${alg2}_${aqm}_100mbps.dat" using 2:xtic(1) title "${alg1}" with linespoints lw 5,\
         "${alg1}_${alg2}_${aqm}_100mbps.dat" using 3:xtic(1) title "${alg2}" with linespoints lw 5,\
         "${alg1}_${alg2}_${aqm}_100mbps.dat" using (\$2+\$3):xtic(1) title "total" with linespoints lw 5

    set title "1Gbps (10 vs 10 flows)" noenhanced
    plot "${alg1}_${alg2}_${aqm}_1gbps.dat" using 2:xtic(1) title "${alg1}" with linespoints lw 5,\
         "${alg1}_${alg2}_${aqm}_1gbps.dat" using 3:xtic(1) title "${alg2}" with linespoints lw 5,\
         "${alg1}_${alg2}_${aqm}_1gbps.dat" using (\$2+\$3):xtic(1) title "total" with linespoints lw 5
    
    set title "25Gbps (250 vs 250 flows)" noenhanced
    #set key above vertical maxrows 1 right font "Calibri, 18"
    plot "${alg1}_${alg2}_${aqm}_25gbps.dat" using 2:xtic(1) title "${alg1}" with linespoints lw 5,\
         "${alg1}_${alg2}_${aqm}_25gbps.dat" using 3:xtic(1) title "${alg2}" with linespoints lw 5,\
         "${alg1}_${alg2}_${aqm}_25gbps.dat" using (\$2+\$3):xtic(1) title "total" with linespoints lw 5
    
    set title "500Mbps (5 vs 5 flows)" noenhanced
    plot "${alg1}_${alg2}_${aqm}_500mbps.dat" using 2:xtic(1) title "${alg1}" with linespoints lw 5,\
         "${alg1}_${alg2}_${aqm}_500mbps.dat" using 3:xtic(1) title "${alg2}" with linespoints lw 5,\
         "${alg1}_${alg2}_${aqm}_500mbps.dat" using (\$2+\$3):xtic(1) title "total" with linespoints lw 5

    set title "10Gbps (100 vs 100 flows)" noenhanced
    plot "${alg1}_${alg2}_${aqm}_10gbps.dat" using 2:xtic(1) title "${alg1}" with linespoints lw 5,\
         "${alg1}_${alg2}_${aqm}_10gbps.dat" using 3:xtic(1) title "${alg2}" with linespoints lw 5,\
         "${alg1}_${alg2}_${aqm}_10gbps.dat" using (\$2+\$3):xtic(1) title "total" with linespoints lw 5
EOC

done

cd ${cwd}

fi
done


#### EXTRA MULTIPLOTS ####

folders_of_interest=("bbr_bbr" "cubic_cubic" "bbr2_bbr2" "reno_reno" "htcp_htcp")
for i in ${folders_of_interest[@]}; do
if [[ -d parsed_data_plots/$i ]]; then

echo "$i - ${i%_*} - ${i#*_}"
alg1=${i%_*}
alg2=${i#*_}

cd ${cwd}/parsed_data_plots/${i}
    
for aqm in ${aqms[@]}; do

echo "#bws,#bw_num,alg1_mean_throughput_2BDP,alg2_mean_throughput_2BDP,alg1_mean_retx_packets_2BDP,alg2_mean_retx_packets_2BDP,fairness_2BDP,alg1_mean_throughput_16BDP,alg2_mean_throughput_16BDP,alg1_mean_retx_packets_16BDP,alg2_mean_retx_packets_16BDP,fairness_16BDP" > "${alg1}_${alg2}_${aqm}_transformed.dat"
for bw in ${bws[@]}; do
  if [[ ${bw} == *"mbps"* ]]; then
    bw_num=${bw%mbps*}
  else
    bw_num=$((${bw%gbps*}*1000))
  fi
  echo "${bw},${bw_num},$(grep '2BDP' ${alg1}_${alg2}_${aqm}_${bw}*.dat | cut -d',' -f 2,3,4,5,6),$(grep '16BDP' ${alg1}_${alg2}_${aqm}_${bw}*.dat | cut -d',' -f 2,3,4,5,6)" >> "${alg1}_${alg2}_${aqm}_transformed.dat"
done

for j in {1..10}; do
  sed -i 's/,0\.0,/,0\.0001,/g' "${alg1}_${alg2}_${aqm}_transformed.dat"
done

done
cd ${cwd}
fi
done

for aqm in ${aqms[@]}; do

filename="parsed_data_plots/throughput_2bdp_16bdp_${aqm}_lines.pdf"
echo $filename
gnuplot<<EOC
    reset
    set terminal pdf size 10,12 font "Calibri, 26"
    set output "$filename"
    set datafile separator ","

    set multiplot layout 2,1 columns
    
    set notitle
    
    set ylabel "2BDP - Throughput Mbps"
    #set logscale y
    unset xlabel
    set key above vertical maxrows 1 right font "Calibri, 22"
    
    plot "parsed_data_plots/bbr_bbr/bbr_bbr_${aqm}_transformed.dat" using (\$3+\$4):xtic(1) title "BBRv1" with linespoints lw 5 pt 1,\
         "parsed_data_plots/bbr2_bbr2/bbr2_bbr2_${aqm}_transformed.dat" using (\$3+\$4):xtic(1) title "BBRv2" with linespoints lw 5 pt 3,\
         "parsed_data_plots/reno_reno/reno_reno_${aqm}_transformed.dat" using (\$3+\$4):xtic(1) title "RENO" with linespoints lw 5 pt 5,\
         "parsed_data_plots/htcp_htcp/htcp_htcp_${aqm}_transformed.dat" using (\$3+\$4):xtic(1) title "HTCP" with linespoints lw 5 pt 7,\
         "parsed_data_plots/cubic_cubic/cubic_cubic_${aqm}_transformed.dat" using (\$3+\$4):xtic(1) title "CUBIC" with linespoints lw 5 pt 9

    set ylabel "16BDP - Throughput Mbps"
    set xlabel "Bandwidth"
    unset key
    
    plot "parsed_data_plots/bbr_bbr/bbr_bbr_${aqm}_transformed.dat" using (\$8+\$9):xtic(1) title "BBRv1" with linespoints lw 5 pt 1,\
         "parsed_data_plots/bbr2_bbr2/bbr2_bbr2_${aqm}_transformed.dat" using (\$8+\$9):xtic(1) title "BBRv2" with linespoints lw 5 pt 3,\
         "parsed_data_plots/reno_reno/reno_reno_${aqm}_transformed.dat" using (\$8+\$9):xtic(1) title "RENO" with linespoints lw 5 pt 5,\
         "parsed_data_plots/htcp_htcp/htcp_htcp_${aqm}_transformed.dat" using (\$8+\$9):xtic(1) title "HTCP" with linespoints lw 5 pt 7,\
         "parsed_data_plots/cubic_cubic/cubic_cubic_${aqm}_transformed.dat" using (\$8+\$9):xtic(1) title "CUBIC" with linespoints lw 5 pt 9
EOC

filename="parsed_data_plots/throughput_2bdp_16bdp_${aqm}_lines_normalized.pdf"
echo $filename
gnuplot<<EOC
    reset
    set terminal pdf size 10,12 font "Calibri, 26"
    set output "$filename"
    set datafile separator ","

    set multiplot layout 2,1 columns
    
    set notitle
    
    set ylabel "2BDP - Normalized Throughput"
    #set logscale y
    unset xlabel
    set key above vertical maxrows 1 right font "Calibri, 22"
    set yrange [0:]
    
    plot "parsed_data_plots/bbr_bbr/bbr_bbr_${aqm}_transformed.dat" using ((\$3+\$4)/\$2):xtic(1) title "BBRv1" with linespoints lw 5 pt 1,\
         "parsed_data_plots/bbr2_bbr2/bbr2_bbr2_${aqm}_transformed.dat" using ((\$3+\$4)/\$2):xtic(1) title "BBRv2" with linespoints lw 5 pt 3,\
         "parsed_data_plots/reno_reno/reno_reno_${aqm}_transformed.dat" using ((\$3+\$4)/\$2):xtic(1) title "RENO" with linespoints lw 5 pt 5,\
         "parsed_data_plots/htcp_htcp/htcp_htcp_${aqm}_transformed.dat" using ((\$3+\$4)/\$2):xtic(1) title "HTCP" with linespoints lw 5 pt 7,\
         "parsed_data_plots/cubic_cubic/cubic_cubic_${aqm}_transformed.dat" using ((\$3+\$4)/\$2):xtic(1) title "CUBIC" with linespoints lw 5 pt 9

    set ylabel "16BDP - Normalized Throughput"
    set xlabel "Bandwidth"
    unset key
    
    plot "parsed_data_plots/bbr_bbr/bbr_bbr_${aqm}_transformed.dat" using ((\$8+\$9)/\$2):xtic(1) title "BBRv1" with linespoints lw 5 pt 1,\
         "parsed_data_plots/bbr2_bbr2/bbr2_bbr2_${aqm}_transformed.dat" using ((\$8+\$9)/\$2):xtic(1) title "BBRv2" with linespoints lw 5 pt 3,\
         "parsed_data_plots/reno_reno/reno_reno_${aqm}_transformed.dat" using ((\$8+\$9)/\$2):xtic(1) title "RENO" with linespoints lw 5 pt 5,\
         "parsed_data_plots/htcp_htcp/htcp_htcp_${aqm}_transformed.dat" using ((\$8+\$9)/\$2):xtic(1) title "HTCP" with linespoints lw 5 pt 7,\
         "parsed_data_plots/cubic_cubic/cubic_cubic_${aqm}_transformed.dat" using ((\$8+\$9)/\$2):xtic(1) title "CUBIC" with linespoints lw 5 pt 9
EOC

filename="parsed_data_plots/retx_2bdp_16bdp_${aqm}_lines.pdf"
echo $filename
gnuplot<<EOC
    reset
    set terminal pdf size 10,12 font "Calibri, 26"
    set output "$filename"
    set datafile separator ","

    set multiplot layout 2,1 columns
    
    set notitle
    
    set ylabel "2BDP - reTX Packets (log)"
    set logscale y
    unset xlabel
    set key above vertical maxrows 1 right font "Calibri, 22"
    
    plot "parsed_data_plots/bbr_bbr/bbr_bbr_${aqm}_transformed.dat" using (\$5+\$6):xtic(1) title "BBRv1" with linespoints lw 5 pt 1,\
         "parsed_data_plots/bbr2_bbr2/bbr2_bbr2_${aqm}_transformed.dat" using (\$5+\$6):xtic(1) title "BBRv2" with linespoints lw 5 pt 3,\
         "parsed_data_plots/reno_reno/reno_reno_${aqm}_transformed.dat" using (\$5+\$6):xtic(1) title "RENO" with linespoints lw 5 pt 5,\
         "parsed_data_plots/htcp_htcp/htcp_htcp_${aqm}_transformed.dat" using (\$5+\$6):xtic(1) title "HTCP" with linespoints lw 5 pt 7,\
         "parsed_data_plots/cubic_cubic/cubic_cubic_${aqm}_transformed.dat" using (\$5+\$6):xtic(1) title "CUBIC" with linespoints lw 5 pt 9

    set ylabel "16BDP - reTX Packets (log)"
    set xlabel "Bandwidth"
    unset key
    
    plot "parsed_data_plots/bbr_bbr/bbr_bbr_${aqm}_transformed.dat" using (\$10+\$11):xtic(1) title "BBRv1" with linespoints lw 5 pt 1,\
         "parsed_data_plots/bbr2_bbr2/bbr2_bbr2_${aqm}_transformed.dat" using (\$10+\$11):xtic(1) title "BBRv2" with linespoints lw 5 pt 3,\
         "parsed_data_plots/reno_reno/reno_reno_${aqm}_transformed.dat" using (\$10+\$11):xtic(1) title "RENO" with linespoints lw 5 pt 5,\
         "parsed_data_plots/htcp_htcp/htcp_htcp_${aqm}_transformed.dat" using (\$10+\$11):xtic(1) title "HTCP" with linespoints lw 5 pt 7,\
         "parsed_data_plots/cubic_cubic/cubic_cubic_${aqm}_transformed.dat" using (\$10+\$11):xtic(1) title "CUBIC" with linespoints lw 5 pt 9
EOC

filename="parsed_data_plots/fairness_2bdp_16bdp_${aqm}_lines.pdf"
echo $filename
gnuplot<<EOC
    reset
    set terminal pdf size 10,12 font "Calibri, 26"
    set output "$filename"
    set datafile separator ","

    set multiplot layout 2,1 columns
    
    set notitle
    
    set ylabel "2BDP - Fairness Index"
    set yrange [0:]
    unset xlabel
    set key above vertical maxrows 1 right font "Calibri, 22"
    
    plot "parsed_data_plots/bbr_bbr/bbr_bbr_${aqm}_transformed.dat" using 7:xtic(1) title "BBRv1" with linespoints lw 5 pt 1,\
         "parsed_data_plots/bbr2_bbr2/bbr2_bbr2_${aqm}_transformed.dat" using 7:xtic(1) title "BBRv2" with linespoints lw 5 pt 3,\
         "parsed_data_plots/reno_reno/reno_reno_${aqm}_transformed.dat" using 7:xtic(1) title "RENO" with linespoints lw 5 pt 5,\
         "parsed_data_plots/htcp_htcp/htcp_htcp_${aqm}_transformed.dat" using 7:xtic(1) title "HTCP" with linespoints lw 5 pt 7,\
         "parsed_data_plots/cubic_cubic/cubic_cubic_${aqm}_transformed.dat" using 7:xtic(1) title "CUBIC" with linespoints lw 5 pt 9

    set ylabel "16BDP - Fairness Index"
    set xlabel "Bandwidth"
    unset key
    
    plot "parsed_data_plots/bbr_bbr/bbr_bbr_${aqm}_transformed.dat" using 12:xtic(1) title "BBRv1" with linespoints lw 5 pt 1,\
         "parsed_data_plots/bbr2_bbr2/bbr2_bbr2_${aqm}_transformed.dat" using 12:xtic(1) title "BBRv2" with linespoints lw 5 pt 3,\
         "parsed_data_plots/reno_reno/reno_reno_${aqm}_transformed.dat" using 12:xtic(1) title "RENO" with linespoints lw 5 pt 5,\
         "parsed_data_plots/htcp_htcp/htcp_htcp_${aqm}_transformed.dat" using 12:xtic(1) title "HTCP" with linespoints lw 5 pt 7,\
         "parsed_data_plots/cubic_cubic/cubic_cubic_${aqm}_transformed.dat" using 12:xtic(1) title "CUBIC" with linespoints lw 5 pt 9
EOC

done

#clean transformed data
#for i in $(find . -name *transformed.dat); do rm -f $i; done

#clean parsed data
#for i in $(find . -name *.dat); do rm -f $i; done

#clean plots
#for i in $(find . -name *.pdf); do rm -f $i; done

