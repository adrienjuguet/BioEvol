#include "GridCell.h"
#include "/usr/local/cuda/include/cuda_runtime_api.h"	//chemin nécessaire sur Grid5000 (Lyon)
#include "/usr/local/cuda/include/cuda.h"
//#include <cuda.h>
//#include <cuda_runtime_api.h>
#ifndef PDC_EVOL_MODEL_CUDA_H
#define PDC_EVOL_MODEL_CUDA_H

void cuda_call4(int height, int width, GridCell** CpuGrid);

__global__
void kernel(GridCell *inGpuGrid, GridCell *outGpuGrid, long gridSize);

#endif //PDC_EVOL_MODEL_CUDA_H
