/***************
* lock-omp.c
* Thomas Kinch
* 5/22/18
**************/
#include <stdio.h>
#include <omp.h>
#include <unistd.h>

int main(){

	omp_lock_t lck;
	omp_init_lock(&lck);

	#pragma omp parallel num_threads(8) 
	{
		#pragma omp master
			omp_set_lock(&lck);
			printf("Lock set by thread %d\n", omp_get_thread_num());
			omp_unset_lock(&lck);
		/*
		if ((omp_get_thread_num()) == 0) {
			  omp_set_lock(&lck);
			  printf("Lock set by thread %d\n", omp_get_thread_num()); 
			  sleep(2);
			  printf("Waited 2 seconds\n");
			  omp_unset_lock(&lck);
		}
		else {
			  omp_set_lock(&lck);
			  printf("Lock set by thread %d\n", omp_get_thread_num());
			  sleep(1);
			  printf("Waited 1 second\n");
			  omp_unset_lock(&lck);
		}
		*/
	}
	return 0;
}
