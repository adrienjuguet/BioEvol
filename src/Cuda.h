#include "GridCell.h"
#include <cuda_runtime_api.h>
#include <cuda.h>
#ifndef PDC_EVOL_MODEL_CUDA_H
#define PDC_EVOL_MODEL_CUDA_H

void cuda_call4(int height, int width, GridCell** CpuGrid);

__global__
void kernel(GridCell *inGpuGrid, GridCell *outGpuGrid, long gridSize);

#endif //PDC_EVOL_MODEL_WORLD_H