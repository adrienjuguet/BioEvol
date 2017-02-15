#!/usr/bin/python
import subprocess
import sys

def avg(tab) :
        to_ret = 0
        for i in tab:
                to_ret+= i
        to_ret /= len(tab)
        return to_ret

def test(i, size) :
	print("{} threads".format(i))
        output = []
        for k in range(10) :
		return_exe = subprocess.Popen(["../pdc_evol_model", str(i), str(size)], stdout=subprocess.PIPE).communicate()[0]
                try :
			output.append(int(return_exe))
		except ValueError : 
			print("error ! {}".format(return_exe))
			print ("retry")
			return_exe = subprocess.Popen(["../pdc_evol_model", str(i), str(size)], stdout=subprocess.PIPE).communicate()[0]
			try : 
				output.append(int(return_exe))
			except ValueError : 
				print("error next iteration !")

		print ("Iteration {} : {}".format(k,output))
		
        return avg(output)

size = sys.argv[1]
print("matrice {}x{}".format(size,size))
stats = {}

for i in range(16, 65, 2):
	stats[i] = test(i,size)

file = open("output/output_16to64_size"+str(size)+".csv", "w")
for k, v in stats.items():
        file.write("{},{}\n".format(k, v))
file.close()

subprocess.call(["rm", "-rf", "stats_best.txt"])
subprocess.call(["rm", "-rf", "stats_mean.txt"])

