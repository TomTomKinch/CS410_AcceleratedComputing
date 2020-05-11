/***************
* lock-omp-partc.c
* Thomas Kinch
* 5/30/18
**************/
#include <stdio.h>
#include <omp.h>
#include <unistd.h>
#include <time.h>

int main(){

	omp_lock_t lck;
	omp_init_lock(&lck);
	
	int total = 0;
	int calc = 0;

	#pragma omp parallel num_threads(8) shared(total)
	{	

		#pragma omp master
		{
			omp_set_lock(&lck);
			printf("Lock set by thread %d\n", omp_get_thread_num());	  	
			sleep(2);	
			printf("Total = %d\n", total);
			printf("Total/ thread# = ERR\n");
			printf("Cannot divide by zero\n");

			omp_unset_lock(&lck);
		}

		if((omp_get_thread_num()) != 0)
		{
			omp_set_lock(&lck);
			printf("Lock set by thread %d\n", omp_get_thread_num());	  	
			sleep(1);
			for(int i = 0; i < 10000; i++){
				total = total + omp_get_thread_num();
			}

			calc = total / omp_get_thread_num();
			
			printf("Total = %d\n", total);
			printf("Total/ thread# = %d\n", calc);
			omp_unset_lock(&lck);
		}
	}

	return 0;
}
