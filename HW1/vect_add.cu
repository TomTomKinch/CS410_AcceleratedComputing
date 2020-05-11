/*******************************************
* vect_add.cu
* By: Thomas Kinch
* 4/11/18
* A basic add vector program using CUDA.
*******************************************/

#include <cuda.h>
#include <stdio.h>
#define threads 512

__global__ void vecAdd(int *d_a, int *d_b, int *d_c){
	int i = threadIdx.x;
	if(i < threads){
		d_c[i] = d_a[i] + d_b[i];
	}
} 

int main(){
	int *h_a, *h_b, *h_c; //Host variables	
	int *d_a, *d_b, *d_c; //Device
	int size = threads * sizeof(int);

	//Malloc memory for host variables
	h_a = (int*)malloc(size);
	h_b = (int*)malloc(size);
	h_c = (int*)malloc(size);
	
	//Define Host variables
	for(int i = 0; i < threads; i++){
		h_a[i] = i;
		h_b[i] = i;
	}

	//Malloc memory for device variables
	cudaMalloc((void**)&d_a, size);
	cudaMalloc((void**)&d_b, size);
	cudaMalloc((void**)&d_c, size);

	//Memcpy - copy host values to device
	cudaMemcpy(d_a, h_a, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, h_b, size, cudaMemcpyHostToDevice);
		
	//Add the Vectors
	vecAdd<<<1, threads>>>(d_a, d_b, d_c);
	cudaThreadSynchronize();

	//Copy device result to the host
	cudaMemcpy(h_c, d_c, size, cudaMemcpyDeviceToHost);

	//Print host_c variables
	for(int i = 0; i < 20; i++){
		printf("h_c[%d] = %d\n", i, h_c[i]);
	}
	
	//Free memory
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);

	free(h_a);
	free(h_b);
	free(h_c);

	return 0;
}
