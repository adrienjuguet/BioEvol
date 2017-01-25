#include "Cuda.h"
#include <iostream>

/****************************CUDA****************************/
__global__
void kernel_sum_metabolic_error(GridCell * inGpuGridCell, float * inGpuMetabolic,float * outSum, int metabolic_size)
{
	/*
  for (int i = 0; i < Common::Metabolic_Error_Precision; i++) {
    sum_metabolic_error+=std::abs(gridcell_->environment_target[i]-metabolic_error[i]);
  }
  	*/
}

void cuda_call_sum_metabolic_error(int metabolic_size, GridCell* gridcell, float* metabolic)
{		
	
	long metabolicSize = sizeof(float)*metabolic_size;
	
	GridCell* inGpuGridCell;
	float * inGpuMetabolic;
	float * outSum;
	cudaError_t ok;
	
	/**Allocation mémoire GPU**/
	ok = cudaMalloc((void**) &inGpuGridCell, sizeof(GridCell*));
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur d'allocation mémoire inGpuGridCell !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return;
	}
	
	ok = cudaMalloc((void**) &inGpuMetabolic, metabolicSize);
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur d'allocation mémoire inGpuMetabolic !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return;
	}

	ok = cudaMalloc((void**) &outSum, sizeof(float));
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur d'allocation mémoire out !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return;
	}
	/**************************/
	
	/**Init inGpuGridCell & inGpuMetabolic**/
	ok = cudaMemcpy(inGpuGridCell, gridcell, sizeof(GridCell*),cudaMemcpyHostToDevice);
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur de copie mémoire inGpuGridCell !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return;
	}
	ok = cudaMemcpy(inGpuMetabolic, metabolic, metabolicSize,cudaMemcpyHostToDevice);
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur de copie mémoire inGpuMetabolic !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return;
	}
	/******************/

	dim3 dimBlock(32);
	dim3 dimGrid(metabolicSize/dimBlock.x);
	
	kernel_sum_metabolic_error<<<dimGrid, dimBlock>>>(inGpuGridCell, inGpuMetabolic, outSum, metabolic_size);
	
	cudaThreadSynchronize();
	ok = cudaGetLastError();
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur du kernel !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return;
	}
		
	/**Récupération des valeurs sur le CPU**/
	/*double * sum;
	ok = cudaMemcpy(sum, outSum, sizeof(float), cudaMemcpyDeviceToHost);
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur de copie mémoire out !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return;
	}*/
	/***************************************/
	
	/**Libération de la mémoire**/
	ok = cudaFree(inGpuGridCell);
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur de libération mémoire inGpuGridCell !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok) << std::endl;
		return;
	}
	ok = cudaFree(inGpuMetabolic);
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur de libération mémoire inGpuMetabolic !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return;
	}
	ok = cudaFree(outSum);
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur de libération mémoire outSum !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return;
	}
	/****************************/
}


/************************************************************/
