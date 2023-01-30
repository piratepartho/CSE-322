rm data.csv
echo "area,nodes,flows,sent_packet,dropped_packet,received_packet,throughput,delay,delievery_ratio,drop_ratio" >> data.csv

# ns 1805107.tcl
# awk -f parse.awk trace.tr  >> data.csv

for area in 250 500 750 1000 1250
do
ns 1805107.tcl $area 40 20
awk -f parse.awk trace.tr  >> data.csv
done

for node in 20 40 60 80 100
do
ns 1805107.tcl 500 $node 20
awk -f parse.awk trace.tr  >> data.csv
done

for flow in 10 20 30 40 50
do
ns 1805107.tcl 500 40 $flow
awk -f parse.awk trace.tr  >> data.csv
done