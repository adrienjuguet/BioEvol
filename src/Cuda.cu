#include "Cuda.h"
#include <iostream>

/****************************CUDA****************************/
__global__
void kernel_sum_metabolic_error(GridCell * inGpuGridCell, float * inGpuMetabolic,float * outSum, int * metabolic_size)
{
  	uint threadId = blockIdx.x * blockDim.x + threadIdx.x;
  	
  	float sum = 0;
  	if(threadId < *metabolic_size){
		sum = inGpuGridCell->environment_target[threadId]-inGpuMetabolic[threadId];
		if(sum < 0){
			sum *= -1;
		}
	}
	atomicAdd(outSum,sum);
}

float cuda_call_sum_metabolic_error(int metabolic_size, GridCell* gridcell, float* metabolic)
{		
	
	long metabolicSize = sizeof(float)*metabolic_size;
	
	GridCell* inGpuGridCell;
	float * inGpuMetabolic;
	int * inGpuMetabolicSize;
	float * outSum;
	cudaError_t ok;
	
	/**Allocation mémoire GPU**/
	ok = cudaMalloc((void**) &inGpuGridCell, sizeof(GridCell*));
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur d'allocation mémoire inGpuGridCell !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return -1;
	}
	
	ok = cudaMalloc((void**) &inGpuMetabolic, metabolicSize);
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur d'allocation mémoire inGpuMetabolic !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return -1;
	}

	ok = cudaMalloc((void**) &outSum, sizeof(float*));
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur d'allocation mémoire out !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return -1;
	}
	ok = cudaMalloc((void**) &inGpuMetabolicSize, sizeof(int));
        if(ok != cudaSuccess)
        {
                std::cout << "Erreur d'allocation mémoire metabolic_size !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
                return -1;
        }

	/**************************/
	
	/**Init inGpuGridCell & inGpuMetabolic**/
	ok = cudaMemcpy(inGpuGridCell, gridcell, sizeof(GridCell*),cudaMemcpyHostToDevice);
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur de copie mémoire inGpuGridCell !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return -1;
	}
	ok = cudaMemcpy(inGpuMetabolic, metabolic, metabolicSize,cudaMemcpyHostToDevice);
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur de copie mémoire inGpuMetabolic !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return -1;
	}
	int * ptr_metabolic_size = &metabolic_size; 
	ok = cudaMemcpy(inGpuMetabolicSize, ptr_metabolic_size, sizeof(int),cudaMemcpyHostToDevice);
        if(ok != cudaSuccess)
        {
                std::cout << "Erreur de copie mémoire metabolic_size !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
                return -1;
        }

	/******************/

	dim3 dimBlock(32);
	dim3 dimGrid(metabolicSize/dimBlock.x);
	
	std::cout << "starting kernel :" << ok << std::endl;	
	kernel_sum_metabolic_error<<<dimGrid, dimBlock>>>(inGpuGridCell, inGpuMetabolic, outSum, inGpuMetabolicSize);
	std::cout << "end kernel :" << ok << std::endl;
	
	getchar();
	cudaThreadSynchronize();
	std::cout << "end thread synchronize :" << ok << std::endl;

	ok = cudaGetLastError();
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur du kernel !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return -1;
	}
		
	/**Récupération des valeurs sur le CPU**/
	float * sum = 0;
	ok = cudaMemcpy(sum, outSum, sizeof(float*), cudaMemcpyDeviceToHost);
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur de copie mémoire out !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		std::cout << "sum :" << *sum << std::endl;
		std::cout << "outSum :" << *outSum << std::endl;		
		return -1;
	}
	/***************************************/
	
	/**Libération de la mémoire**/
	ok = cudaFree(inGpuGridCell);
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur de libération mémoire inGpuGridCell !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok) << std::endl;
		return -1;
	}
	ok = cudaFree(inGpuMetabolic);
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur de libération mémoire inGpuMetabolic !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return -1;
	}
	ok = cudaFree(outSum);
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur de libération mémoire outSum !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return -1;
	}
	ok = cudaFree(inGpuMetabolicSize);
        if(ok != cudaSuccess)
        {
                std::cout << "Erreur de libération mémoire metabolic_size !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok) << std::endl;
                return -1;
        }

	/****************************/
	return * sum;
}


/************************************************************/
