/*****************
* bubble_sort.c
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
	printf("\n");

//Begin Sort
	for(int i = 0; i < N; i++){
		bool stop = true;
		for(int j = 0; j < N - 1; j++){
			if(B[j] > B[j+1]){	
				swap(&B[j], &B[j+1]);
				stop = false;
			}

			if(stop) break;
		}
	}

//Print
	printf("Sorted Array: \n");
	for(int k = 0; k < N; k++){
		printf("%d ", B[k]);
	}
	printf("\n");

	return 0;
}
