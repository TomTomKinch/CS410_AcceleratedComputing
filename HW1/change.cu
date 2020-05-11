/*******************************************
* vect_add.cu
* By: Thomas Kinch
* 4/11/18
* A basic add vector program using CUDA.
*******************************************/

#include <cuda.h>
#include <stdio.h>
#define n 512

__global__ void add(float *d_a, float *d_b, float *d_c){
	d_c[blockIdx.x] = d_a[blockIdx.x] + d_b[blockIdx.x];
}

int main(){
	float *h_a, *h_b, *h_c; //Host variables

	//Malloc memory for host variables
	h_a = (float*)malloc(n * sizeof(float));
	h_b = (float*)malloc(n * sizeof(float));
	h_c = (float*)malloc(n * sizeof(float));
	
	float *d_a, *d_b, *d_c; //Device
	int size = n * sizeof(float);

	//Malloc memory for device variables
	cudaMalloc((void**)&d_a, size);
	cudaMalloc((void**)&d_b, size);
	cudaMalloc((void**)&d_c, size);

	//Memcpy - copy host values to device
	cudaMemcpy(d_a, h_a, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, h_b, size, cudaMemcpyHostToDevice);
	
	//Add the Vectors
	add<<<size, 1>>>(d_a, d_b, d_c);

	//Copy device result to the host
	cudaMemcpy(h_c, d_c, size, cudaMemcpyDeviceToHost);


	//Define host variables
	for(int i = 0; i < 10; i++){
		printf("h_c[%d] = %.1f\n", i, h_c[i]);
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
