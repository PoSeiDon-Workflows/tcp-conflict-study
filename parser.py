#!/usr/bin/env python3

import os
import pandas as pd
import pickle

def main():
    aqm_config = ["fifo", "fq_codel", "red", "red_noecn"]

    speed_config = [
        {"tag": "100mbps", "speed": 100000000, "processes": 1, "parallel_streams": 1},
        {"tag": "500mbps", "speed": 500000000, "processes": 5, "parallel_streams": 1},
        {"tag": "1gbps", "speed": 1000000000, "processes": 10, "parallel_streams": 1},
        {"tag": "10gbps", "speed": 10000000000, "processes": 20, "parallel_streams": 5},
        {"tag": "25gbps", "speed": 25000000000, "processes": 25, "parallel_streams": 10}
    ]

    cca_config = [
        {"cca1": "bbr", "cca2": "cubic"},
        {"cca1": "bbr2", "cca2": "cubic"},
        {"cca1": "htcp", "cca2": "cubic"},
        {"cca1": "reno", "cca2": "cubic"},
        {"cca1": "cubic", "cca2": "cubic"},
        {"cca1": "bbr", "cca2": "bbr"},
        {"cca1": "bbr2", "cca2": "bbr2"},
        {"cca1": "htcp", "cca2": "htcp"},
        {"cca1": "reno", "cca2": "reno"}
    ]

    bdp_config = [0.5, 1, 2, 4, 8, 16]

    sender_1_output = "poseidon-sender-1/output"
    sender_2_output = "poseidon-sender-2/output"
    
    rows = []
    for aqm in aqm_config:
        for cca_combo in cca_config:
            for speed in speed_config:
                for bdp in bdp_config:
                    for run in range(1,6):
                        row = {
                            "aqm": aqm, 
                            "cca1": cca_combo['cca1'],
                            "cca2": cca_combo['cca2'],
                            "speed": speed['tag'], 
                            "bdp": bdp,
                            "run": run
                        }

                        #sender 1
                        f1 = f"raw_data/{sender_1_output}/{speed['tag']}_{cca_combo['cca1']}_{cca_combo['cca2']}_{aqm}_{bdp}bdp_{run}.total"
                        #semder 2
                        f2 = f"raw_data/{sender_2_output}/{speed['tag']}_{cca_combo['cca2']}_{cca_combo['cca1']}_{aqm}_{bdp}bdp_{run}.total"
                        
                        with open(f1, 'r') as f:
                            lines = f.readlines()
                            measurements = list(map(float, lines[1].replace("\n",'').split(",")))
                            row["sender_1_goodput"] = measurements[0]
                            row["sender_1_retransmits"] = measurements[1]

                        with open(f2, 'r') as f:
                            lines = f.readlines()
                            measurements = list(map(float, lines[1].replace("\n",'').split(",")))
                            row["sender_2_goodput"] = measurements[0]
                            row["sender_2_retransmits"] = measurements[1]
                        
                        rows.append(row)

    results = pd.DataFrame.from_dict(rows)

    #with open('results.pickle', 'wb') as handle:
    #    pickle.dump(results, handle, protocol=pickle.HIGHEST_PROTOCOL)

    agg_results = results.drop(columns=["run"]).groupby(by=["aqm", "cca1", "cca2", "speed", "bdp"]).aggregate("mean")
    
    header = ["#BDP", "alg1_mean_throughput", "alg2_mean_throughput", "alg1_mean_retx_packets", "alg2_mean_retx_packets", "fairness_index"]
    
    for aqm in aqm_config:
        for cca_combo in cca_config:
            for speed in speed_config:
                output_buffer = [header]
                for bdp in bdp_config:
                    index = (aqm, cca_combo["cca1"], cca_combo["cca2"], speed["tag"], float(bdp))
                    data = agg_results.loc[index]
                    fairness_index = round(((data["sender_1_goodput"]+data["sender_2_goodput"])**2)/(2.0*(data["sender_1_goodput"]**2 + data["sender_2_goodput"]**2)), 4)

                    output_buffer.append([
                        f"{bdp}BDP",
                        round(data["sender_1_goodput"], 2),
                        round(data["sender_2_goodput"], 2),
                        round(data["sender_1_retransmits"], 2),
                        round(data["sender_2_retransmits"], 2),
                        fairness_index
                    ])

                output_dir = f"parsed_data_plots/{cca_combo['cca1']}_{cca_combo['cca2']}"
                output_file = f"{cca_combo['cca1']}_{cca_combo['cca2']}_{aqm}_{speed['tag']}.dat"
                abs_output_file = os.path.join(output_dir, output_file)
                
                try:
                    os.mkdir(output_dir)
                except:
                    pass

                with open(abs_output_file, "w+") as g:
                    for line in output_buffer:
                        g.write(f"{','.join(map(str,line))}\n")

if __name__== "__main__":
    main()
