/*****************
* bubble_omp.c
* Thomas Kinch 
* 5/30/18
*****************/

#include <stdio.h>
#include <omp.h>
#include <stdbool.h>


void swap(int *B1, int *B2){
	int temp = *B1;
	*B1 = *B2;
	*B2 = temp;
}

int main(){	  
	int B[6] = {6, 4, 3, 1, 2, 5};
	int N = sizeof(B)/sizeof(B[0]); //Size of Array	
	
	printf("Array Before: \n");
	for(int k = 0; k < N; k++){
		printf("%d ", B[k]);
	}
	printf("\n---------------\n");

//Begin Sort
	bool stop = false;
	while(stop == false){
		#pragma omp parallel
		{
			stop = true;
			#pragma omp for
				for(int i = 0; i < N - 1; i += 2){
					stop = true;
					if(B[i] > B[i+1]){
						swap(&B[i], &B[i+1]);
						stop = false;
					}
					/*
					for(int k = 0; k < N; k++){
						printf("%d ", B[k]);
					}
					printf("\n");
					*/
				}
			#pragma omp for
				for(int i = 1; i < N - 1; i += 2){
					stop = true;
					if(B[i] > B[i+1]){
						swap(&B[i], &B[i+1]);
						stop = false;
					}
					/*
					for(int k = 0; k < N; k++){
						printf("%d ", B[k]);
					}
					printf("\n");
					*/
				}
		}
	}
//Print
	printf("---------------\n");
	printf("Sorted Array: \n");
	for(int k = 0; k < N; k++){
		printf("%d ", B[k]);
	}
	printf("\n");

	return 0;
}
