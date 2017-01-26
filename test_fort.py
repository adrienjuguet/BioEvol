#!/usr/bin/python
import subprocess
import pygal

def avg(tab) :
        to_ret = 0
        for i in tab:
                to_ret+= i
        to_ret /= len(tab)
        return to_ret

def test(i) :
        print("{} threads".format(i))
        output = []
        for k in range(3) :
                print("Iteration {}".format(k))
                output.append(int(subprocess.Popen(["./pdc_evol_model", str(i)], stdout=subprocess.PIPE).communicate()[0]))
        return avg(output)


stats_1to256 = {}
stats_32to128 = {}

for i in [2**x for x in range(9)] :
        stats_1to256[i] = test(i)

for i in range(32, 129, 2):
	if i in stats_1to256 :
		print("if")
		print("{} threads".format(i))
		stats_32to128[i] = stats_1to256[i]
	else : 
		stats_32to128[i] = test(i)

file = open("output_1to256.csv", "w")
for k, v in stats_1to256.items():
        file.write("{},{}\n".format(k, v))
file.close()

xy_chart_1to256 = pygal.XY(stroke=False)
xy_chart_1to256.title = "Performances"
xy_chart_1to256.add("temps/threads", [(k, v) for k, v in stats_1to256.items()])
xy_chart_1to256.render_to_png("output_1to256.png")

file = open("output_32to128.csv", "w")
for k, v in stats_32to128.items():
        file.write("{},{}\n".format(k, v))
file.close()

xy_chart_32to128 = pygal.XY(stroke=False)
xy_chart_32to128.title = "Performances"
xy_chart_32to128.add("temps/threads", [(k, v) for k, v in stats_32to128.items()])
xy_chart_32to128.render_to_png("output_32to128.png")

