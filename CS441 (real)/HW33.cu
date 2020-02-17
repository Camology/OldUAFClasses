#include "stdio.h"
#define COLUMNS 4 
#define ROWS 3

__global__ void add(int *a, int *b) {
	int x = threadIdx.x;
	int sum =0;
	for (unsigned int i=0; i < ROWS; i++){
		sum += a[i*COLUMNS + x];
	}
	b[x] = sum;
		
}

int main() {
	int a[ROWS][COLUMNS], b[COLUMNS];
	int *dev_a;
	int *dev_b;
	int sum =0;
	int cudSum =0;
	cudaMalloc((void **)&dev_a, ROWS*COLUMNS*sizeof(int));
	cudaMalloc((void **)&dev_b, COLUMNS*sizeof(int));
	
	for(int y=0; y<ROWS; y++) {
		for(int x=0; x<COLUMNS; x++){
			a[y][x] = x;
			sum+= x;
		}
	}
	printf("Sum is: %d \n", sum);
	cudaMemcpy(dev_a, a, ROWS*COLUMNS*sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b, b, COLUMNS*sizeof(int), cudaMemcpyHostToDevice);
	
	dim3 thread(COLUMNS,ROWS);
	add<<<1,COLUMNS>>>(dev_a,dev_b);
	cudaMemcpy(b,dev_b, COLUMNS*sizeof(int),cudaMemcpyDeviceToHost);
	for (int i=0; i<COLUMNS; i++) {
		cudSum+= b[i];
	} 
	printf("cuda sum is: %d \n", cudSum);
	cudaFree(dev_a);
	cudaFree(dev_b);
	return 0;

}
