/********************************************************
* life_seq_cuda.cu
* Modifed BY Thomas Kinch
* Date: 5/14/18
*******************************************************/

/* Compile with `gcc life.c`.
 * When CUDA-fied, compile with `nvcc life.cu`
 */

#include <cuda.h>
#include <stdlib.h> // for rand
#include <string.h> // for memcpy
#include <stdio.h> // for printf
#include <time.h> // for nanosleep

#define WIDTH 60
#define HEIGHT 40
#define threads 256

void fill_board(int *board, int width, int height) {
    int i;
    for (i=0; i<width*height; i++)
        board[i] = rand() % 2;
}

void print_board(int *board) {
    int x, y;
    for (y=0; y<HEIGHT; y++) {
        for (x=0; x<WIDTH; x++) {
            char c = board[y * WIDTH + x] ? '#':' ';
            printf("%c", c);
        }
        printf("\n");
    }
    printf("-----\n");
}


__global__ void step(int *current, int *next, int width, int height) {
	 
	 //Offset
	 const int offsets[8][2] = {{-1, 1},{0, 1},{1, 1},
										 {-1, 0},       {1, 0},
										 {-1,-1},{0,-1},{1,-1}};


	 // coordinates of the cell we're currently evaluating
	 int x = blockIdx.x * width + threadIdx.x;
	 int y = blockIdx.y * height + threadIdx.y;
      
    // offset index, neighbor coordinates, alive neighbor count
    int i, nx, ny, num_neighbors;

    // write the next board state
    for (y=0; y<height; y++) {
        for (x=0; x<width; x++) {

            // count this cell's alive neighbors
            num_neighbors = 0;
            for (i=0; i<8; i++) {
                // To make the board torroidal, we use modular arithmetic to
                // wrap neighbor coordinates around to the other side of the
                // board if they fall off.
                nx = (x + offsets[i][0] + width) % width;
                ny = (y + offsets[i][1] + height) % height;
                if (current[ny * width + nx]) {
                    num_neighbors++;
                }
            }

            // apply the Game of Life rules to this cell
            next[y * width + x] = 0;
            if ((current[y * width + x] && num_neighbors==2) ||
                    num_neighbors==3) {
                next[y * width + x] = 1;
            }
        }
    }
}

int main(int argc, const char *argv[]) {
    // parse the width and height command line arguments, if provided
    int width, height, iters, out;
    if (argc < 3) {
        printf("usage: life iterations 1=print\n"); 
        exit(1);
    }
    iters = atoi(argv[1]);
    out = atoi(argv[2]);
    if (argc == 5) {
        width = atoi(argv[3]);
        height = atoi(argv[4]);
        printf("Running %d iterarions at %d by %d pixels.\n", iters, width, height);
    } else {
        width = WIDTH;
        height = HEIGHT;
    }

    struct timespec delay = {0, 125000000}; // 0.125 seconds
    struct timespec remaining;
    // The two boards 
    int *current, *next, many=0;
	 int *gpu_curr, *gpu_next;

    size_t board_size = sizeof(int) * width * height;
    current = (int *) malloc(board_size); // same as: int current[width * height];
    next = (int *) malloc(board_size);    // same as: int next[width *height];
 

    // Initialize the global "current".
    fill_board(current, width, height);
	 
	 /**************
	 * Cuda Malloc
	 **************/
	 cudaMalloc((void**)&gpu_curr, board_size);
	 cudaMalloc((void**)&gpu_next, board_size);

	 //Begin Iterations
	 clock_t begin, end;
	 double time_spent = 0;
    while (many<iters) {
        many++;
        if (out==1)
			   //Print Current Board
            print_board(current);
 
				/************
				* Cuda memcpy - copy cpu variables to gpu
				*************/
				cudaMemcpy(gpu_curr, current, board_size, cudaMemcpyHostToDevice);
				cudaMemcpy(gpu_next, next, board_size, cudaMemcpyHostToDevice);

				//Utilize Step On GPU
				begin = clock();
				step<<<1, threads>>>(gpu_curr, gpu_next, width, height);
				//cudaThreadSynchronize();
				end = clock();
				time_spent += (double)(end - begin) / CLOCKS_PER_SEC;
				cudaThreadSynchronize();
				//Copy GPU values back to CPU
				cudaMemcpy(current, gpu_curr, board_size, cudaMemcpyDeviceToHost);
				cudaMemcpy(next, gpu_next, board_size, cudaMemcpyDeviceToHost);
				
				memcpy(current, next, board_size);
/*
        //evaluate the `current` board, writing the next generation into `next`.
        step(current, next, width, height);
        // Copy the next state, that step() just wrote into, to current state
        memcpy(current, next, board_size);

        // copy the `next` to CPU and into `current` to be ready to repeat the process

*/
        // We sleep only because textual output is slow and the console needs
        // time to catch up. We don't sleep in the graphical X11 version.
        if (out==1)
            nanosleep(&delay, &remaining);
    }
	 printf("Runtime: %f Seconds\n", time_spent); 

	 //Free Cuda Memory
	 cudaFree(gpu_curr);
	 cudaFree(gpu_next);

    return 0;
}
