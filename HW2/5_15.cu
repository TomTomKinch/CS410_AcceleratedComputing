/****************
 * 5_15.cu
 *
 ***************/

 __shared__ float partialSum[SIZE]; 
 partialSum[threadIdx.x] = X[blockIdx.x * blockDim.x + threadIdx.x];
 unsigned int t = threadIdx.x;
 for (unsigned int stride = blockDim.x/2; stride >= 1; strdie = stride>>1)
 {
 
 __syncthreads();
 if (t < stride)
	partialSum(t) += partialSum(t+stride);
 }
