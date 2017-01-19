#include "Cuda.h"
#include <iostream>

/****************************CUDA****************************/
__global__
void kernel(GridCell *inGpuGrid, GridCell *outGpuGrid, long gridSize){
	/*for (int i = 0; i < width_*height_; i++) {
      grid_cell_[i]->diffuse_protein();
      grid_cell_[i]->degrade_protein();
  	}*/


}

void cuda_call4(int height, int width, GridCell** CpuGrid)
{	
	long gridSize = sizeof(GridCell)*height*width;
        GridCell * inGpuGrid;
        GridCell * outGpuGrid;
        cudaError_t ok;
	
	/**Allocation mémoire GPU**/
	ok = cudaMalloc((void**) &inGpuGrid, gridSize);
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur d'allocation mémoire in !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return;
	}

	ok = cudaMalloc((void**) &outGpuGrid, gridSize);
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur d'allocation mémoire out !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return;
	}
	/**************************/
	
	/**Init inGpuGrid**/
	ok = cudaMemcpy(inGpuGrid, CpuGrid, gridSize,cudaMemcpyHostToDevice);
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur de copie mémoire in !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return;
	}
	/******************/

	dim3 dimBlock(32,32);
	dim3 dimGrid(width/dimBlock.x, height/dimBlock.y);
	
	kernel<<<dimGrid, dimBlock>>>(inGpuGrid, outGpuGrid, gridSize);
	
	cudaThreadSynchronize();
	ok = cudaGetLastError();
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur du kernel !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return;
	}
		
	/**Récupération des valeurs sur le CPU**/
	/*ok = cudaMemcpy(CpuGrid, outGpuGrid, gridSize, cudaMemcpyDeviceToHost);
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur de copie mémoire out !  Code d'erreur : "<<ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return;
	}*/
	/***************************************/
	
	/**Libération de la mémoire**/
	ok = cudaFree(inGpuGrid);
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur de libération mémoire in !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok) << std::endl;
		return;
	}
	ok = cudaFree(outGpuGrid);
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur de libération mémoire out !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return;
	}
	/****************************/
}


/************************************************************/
