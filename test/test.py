#!/usr/bin/python
import subprocess

def avg(tab) :
        to_ret = 0
        for i in tab:
                to_ret+= i
        to_ret /= len(tab)
        return to_ret

output = []
for k in range(1) :
	print("Iteration {}".format(k))
	output.append(int(subprocess.Popen(["../pdc_evol_model"], stdout=subprocess.PIPE).communicate()[0]))
print(avg(output))

subprocess.call(["rm", "-rf", "stats_best.txt"])
subprocess.call(["rm", "-rf", "stats_mean.txt"])
