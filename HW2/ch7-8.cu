//Chapter 7 #8
//Thomas Kinch

__global__ void convolution_2D_basic_kernel(float *N, float *M, float *P, int Mask_Width, int Width){
	
	int col = blockIdx.x * blockDim.x + threadIdx.x;  
	int row = blockIdx.y * blockDim.y + threadIdx.y;  
	
	float Pvalue = 0;
	int N_start_point = col - (Mask_Width/2);
	int M_start_point = row - (Mask_Width/2);
	
	for(int i = 0; i < Mask_Width; i++){
		for(int j = 0; j < Mask_Width; j++){
			if(N_start_point + j >=0 && N_start_point + j < width && M_start_point + i >=0 && M_start_point + i < width){
				Pvalue += N[N_start_point + j] * M[M_start_point + i];
			}
		}
	}
	P[col][row] = Pvalue;
}
