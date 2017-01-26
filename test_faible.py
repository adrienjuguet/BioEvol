#!/usr/bin/python
import subprocess
import pygal

def avg(tab) :
        to_ret = 0
        for i in tab:
                to_ret+= i
        to_ret /= len(tab)
        return to_ret

def test(i, k) :
        print("{} threads".format(i))
        output = []
        for k in range(3) :
                print("Iteration {}".format(k))
                output.append(int(subprocess.Popen(["./pdc_evol_model", str(i)+" "+str(k)], stdout=subprocess.PIPE).communicate()[0]))
        return avg(output)

def appel_test(k) :
	stats_1to256 = {}
	stats_32to128 = {}
	for i in [2**x for x in range(9)] :
		stats_1to256[i] = test(i,k)
	for i in range(32, 129, 2):
		if i in stats_1to256 :
			print("{} threads".format(i))
			stats_32to128[i] = stats_1to256[i]
		else :
			stats_32to128[i] = test(i,k)
	return stats_1to256, stats32to128
#-----------------------------------------------#

stats1_32 = {}
stats32_32 = {}
stats1_64 = {}
stats32_64 = {}
stats1_128 = {}
stats32_128 = {}
	
stats1_32, stats32_32 = appel_test(32)
stats1_64, stats32_64 = appel_test(64)
stats1_128, stats32_128 = appel_test(128)

file = open("output_1to256_faible32.csv", "w")
for k, v in stats1_32.items():
	file.write("{},{}\n".format(k, v))
file.close()
file = open("output_1to256_faible64.csv", "w")
for k, v in stats1_64.items():
       	file.write("{},{}\n".format(k, v))
file.close()
file = open("output_1to256_faible64.csv", "w")
for k, v in stats1_128.items():
       	file.write("{},{}\n".format(k, v))
file.close()

xy_chart_1to256 = pygal.XY(stroke=False)
xy_chart_1to256.title = "Performances"
xy_chart_1to256.add("temps/threads 32", [(k, v) for k, v in stats1_32.items()])
xy_chart_1to256.add("temps/threads 64", [(k, v) for k, v in stats1_64.items()])
xy_chart_1to256.add("temps/threads 128", [(k, v) for k, v in stats1_128.items()])
xy_chart_1to256.render_to_png("output_1to256_faible.png")

file = open("output_32to128_faible32.csv", "w")
for k, v in stats32_32.items():
        file.write("{},{}\n".format(k, v))
file.close()
file = open("output_32to128_faible64.csv", "w")
for k, v in stats32_64.items():
        file.write("{},{}\n".format(k, v))
file.close()
file = open("output_32to128_faible64.csv", "w")
for k, v in stats32_128.items():
        file.write("{},{}\n".format(k, v))
file.close()

xy_chart_32to128 = pygal.XY(stroke=False)
xy_chart_32to128.title = "Performances"
xy_chart_32to128.add("temps/threads 32", [(k, v) for k, v in stats32_32.items()])
xy_chart_1to256.add("temps/threads 64", [(k, v) for k, v in stats32_64.items()])
xy_chart_1to256.add("temps/threads 128", [(k, v) for k, v in stats32_128.items()])
xy_chart_32to128.render_to_png("output_32to128.png")
