#include "GridCell.h"
//#include "/usr/local/cuda/include/cuda_runtime_api.h"	//chemin nécessaire sur Grid5000 (Lyon)
//#include "/usr/local/cuda/include/cuda.h"
#include <cuda.h>
#include <cuda_runtime_api.h>
#include <vector>
#ifndef PDC_EVOL_MODEL_CUDA_H
#define PDC_EVOL_MODEL_CUDA_H

__global__
void kernel_sum_metabolic_error(GridCell * , float * ,float * , int );

void cuda_call_sum_metabolic_error(int , GridCell* , float* );

#endif //PDC_EVOL_MODEL_CUDA_H
