#include "Cuda.h"
#include <iostream>

/****************************CUDA****************************/
__global__
void kernel_organism_dyingornot(Protein **inGpuProtein, double outGpuProtein, long proteinSize){
	/*for (int i = 0; i < width_*height_; i++) {
      grid_cell_[i]->diffuse_protein();
      grid_cell_[i]->degrade_protein();
  	}*/
}

void cuda_call_protein(std::vector<Protein*> cpuProtein)
{	
	Protein** protein_iterator = &cpuProtein[0];
	long vectorSize = cpuProtein.size();
	
	long proteinSize = sizeof(Protein*)*vectorSize;
        Protein ** inGpuProtein;
        double * outGpuProtein;
        cudaError_t ok;
	
	/**Allocation mémoire GPU**/
	ok = cudaMalloc((void**) &inGpuProtein, proteinSize);
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur d'allocation mémoire in !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return;
	}

	ok = cudaMalloc((void**) &outGpuProtein, sizeof(double));
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur d'allocation mémoire out !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return;
	}
	/**************************/
	
	/**Init inGpuProtein**/
	ok = cudaMemcpy(inGpuProtein, protein_iterator, proteinSize,cudaMemcpyHostToDevice);
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur de copie mémoire in !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return;
	}
	/******************/

	dim3 dimBlock(32);
	dim3 dimGrid(proteinSize/dimBlock.x);
	
	kernel_organism_dyingornot<<<dimGrid, dimBlock>>>(inGpuProtein, * outGpuProtein, proteinSize);
	
	cudaThreadSynchronize();
	ok = cudaGetLastError();
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur du kernel !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return;
	}
		
	/**Récupération des valeurs sur le CPU**/
	double * sum;
	ok = cudaMemcpy(sum, outGpuProtein, proteinSize, cudaMemcpyDeviceToHost);
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur de copie mémoire out !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return;
	}
	/***************************************/
	
	/**Libération de la mémoire**/
	ok = cudaFree(inGpuProtein);
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur de libération mémoire in !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok) << std::endl;
		return;
	}
	ok = cudaFree(outGpuProtein);
	if(ok != cudaSuccess)
	{
		std::cout << "Erreur de libération mémoire out !  Code d'erreur : "<< ok <<" : " << cudaGetErrorString(ok)<< std::endl;
		return;
	}
	/****************************/
}


/************************************************************/
