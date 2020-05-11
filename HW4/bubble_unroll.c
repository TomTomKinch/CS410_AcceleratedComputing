/*****************
* bubble_unroll.c
* Thomas Kinch 
* 5/30/18
*****************/

#include <stdio.h>
#include <omp.h>
#include <stdbool.h>

int main(){	  
	int B[6] = {6, 4, 3, 1, 2, 5};
	int N = sizeof(B)/sizeof(B[0]); //Size of Array	

	printf("Array Before: \n");
	for(int k = 0; k < N; k++){
		printf("%d ", B[k]);
	}
	printf("\n-----------------\n");

	for(int i = 0; i < N; i++){
		int temp;

		if(B[0] > B[1]){	
			temp = B[0];
			B[0] = B[1];
			B[1] = temp;
		}
		for(int k = 0; k < N; k++){
			printf("%d ", B[k]);
		}
		printf("\n");

		if(B[1] > B[2]){	
			temp = B[1];
			B[1] = B[2];
			B[2] = temp;
		}
		for(int k = 0; k < N; k++){
			printf("%d ", B[k]);
		}
		printf("\n");


		if(B[2] > B[3]){	
			temp = B[2];
			B[2] = B[3];
			B[3] = temp;
		}
		for(int k = 0; k < N; k++){
			printf("%d ", B[k]);
		}
		printf("\n");

		if(B[3] > B[4]){	
			temp = B[3];
			B[3] = B[4];
			B[4] = temp;
		}
		for(int k = 0; k < N; k++){
			printf("%d ", B[k]);
		}
		printf("\n");

		if(B[4] > B[5]){	
			temp = B[4];
			B[4] = B[5];
			B[5] = temp;
		}
		for(int k = 0; k < N; k++){
			printf("%d ", B[k]);
		}
		printf("\n");
}
	printf("-----------------\n");
	printf("Sorted Array: \n");
	for(int k = 0; k < N; k++){
		printf("%d ", B[k]);
	}
	printf("\n");

	return 0;
}
