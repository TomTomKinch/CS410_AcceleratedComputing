#include <stdio.h>
#include "omp.h"

int main(){

	int numthreads = 0;
	
	#pragma omp parallel 
	
	#pragma omp master

		numthreads = omp_get_num_threads();
	
	printf("Initiallizing\n");
	
	int threads;
	int stop = 0;
	while(stop == 0){
		printf("Enter number of threads: ");
		scanf("%d", &threads);
		if(threads <= numthreads){
			if(threads > 0){
				stop = 1;
			}
		}
	}

	#pragma omp parallel for
		for (int i = 0; i < threads; ++i){
			printf("numthreads %d from thread # %d\n", numthreads, omp_get_thread_num());
		}

return 0;
}
