from pandas import read_csv
import matplotlib.pyplot as plt

d = read_csv("data.csv",delimiter=',')
d['throughput'] = d['throughput'] / 1024

xLabels = ["Area(m)","# of Nodes", "# of Flows"]
yLabels = ["Thorughput (Kbits/sec)","Delay(sec)","Packet Delievery Ratio","Packet Drop Ratio"]
xHeader = ['area','nodes','flows']
yHeader = ['throughput','delay','delievery_ratio','drop_ratio']

for x in {0,1,2}:
    for y in {0,1,2,3}:
        plt.xlabel(xLabels[x])
        plt.ylabel(yLabels[y])
        plt.plot(d [ xHeader[x] ] [x*5 : x*5+5] , d [yHeader[y]] [ x*5 : x*5+5 ],marker='o')
        plt.savefig("images/"+yHeader[y]+" vs "+xHeader[x])
        plt.clf()

# plt.xlabel("Area (m*m)")
# plt.ylabel('Delievery Ratio')
# plt.plot(d['area'][0:5], d['delievery_ratio'][0:5],marker='o')
# plt.savefig('delievery vs area.png')
# plt.clf()

# plt.xlabel("Area (m*m)")
# plt.ylabel('Packet Drop Ratio')
# plt.plot(d['area'][0:5], d['drop_ratio'][0:5],marker='o')
# plt.savefig('drop vs area.png')
# plt.clf()
