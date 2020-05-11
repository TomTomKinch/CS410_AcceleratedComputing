/*
 ============================================================================
 Author        : G. Barlas
 Version       : 1.0
 Last modified : December 2014
 License       : Released under the GNU GPL 3.0
 Description   : 
 To build use  : g++ -fopenmp integration_seq.cpp -o integration_seq
 ============================================================================
 */
// Sequential integration of testf
#include <iostream>
#include <math.h>
#include <stdlib.h>
#include "omp.h"

using namespace std;

//---------------------------------------
double testf (double x)
{
  return x * x + 2 * sin (x);
}

//---------------------------------------
double integrate (double st, double en, int div, double (*f) (double))
{
  double localRes = 0;
  double step = (en - st) / div;
  double x;
  x = st;
  localRes = f (st) + f (en);
  localRes /= 2;
  //OpenMP for the loop
  #pragma omp parallel for private(x)
	for (int i = 1; i < div; i++)
	{  
		x = st + i * step;
		double temp = f(x);
		#pragma omp critical
		localRes += temp;
		/*
		x += step;
		localRes += f (x);a
		*/
	} 
  localRes *= step;

  return localRes;
}

//---------------------------------------
int main (int argc, char *argv[])
{

  if (argc == 1)
    {
      cerr << "Usage " << argv[0] << " start end divisions\n";
      exit (1);
    }
  double start, end;
  int divisions;
  start = atof (argv[1]);
  end = atof (argv[2]);
  divisions = atoi (argv[3]);
	
  /*
  //Get Number of threads
  int N = omp_get_max_threads();
  divisions = (divisions /N) * N; //Checking work per thread, making sure it is a multiple of threads(N) 
  double step = (end - start) / divisions;

	//double finalRes = 0;
	*/
  double finalRes = integrate (start, end, divisions, testf);
	/*
  //Allocate array
  double *partial = new double[N];
#pragma omp parallel
	{
		int localDiv = divisions / N;
		int ID = omp_get_thread_num();
		double localStart = start + ID * localDiv * step;
		double localEnd = localStart + localDiv * step;
		//finalRes += integrate (localStart, localEnd, localDiv, testf);
		partial[ID]= integrate (localStart, localEnd, localDiv, testf);
	}

	//Reduction
	double finalRes = partial[0];
	for (int i= 1; i < N; i++)
		finalRes += partial[i];
*/
  cout << finalRes << endl;

  //delete[]partial;

  return 0;
}
