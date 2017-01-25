#include "Protein.h"
//#include "/usr/local/cuda/include/cuda_runtime_api.h"	//chemin nécessaire sur Grid5000 (Lyon)
//#include "/usr/local/cuda/include/cuda.h"
#include <cuda.h>
#include <cuda_runtime_api.h>
#include <vector>
#ifndef PDC_EVOL_MODEL_CUDA_H
#define PDC_EVOL_MODEL_CUDA_H

void cuda_call_protein(std::vector<Protein*> cpuProtein);

__global__
void kernel_organism_dyingornot(Protein **inGpuProtein, double outGpuProtein, long vectorSize);

#endif //PDC_EVOL_MODEL_CUDA_H
