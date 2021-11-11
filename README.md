# Robust-Pricing-for-Balancing-Microgrid
This project implement a robust pricing scheme for balancing microgrid and compare the result with traditional area control error pricing scheme.
 
Check following paper for more detail

"Energy IMbalance Management Using a Robust Pricing Scheme", IEEE Transaction on smart grid v4 2013, Wei-Yu Chiu, Hongjian Sun, H. Vincent Poor

To replicate the simulation result, run microgrid.m The program will load precomputed data and perform simulation in microgrid.

To run the full simulation, first run main.m then run microgrid.m

To model microgrid operation without uncertainty, set line 10 in microgrid.m as 0.

To model microgrid operation with uncertainty from load, generation and market price, set line 10 in microgrid.m as 1.
