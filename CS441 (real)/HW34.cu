#include "stdio.h"
#define COLUMNS 8 
#define ROWS 8

__global__ void add(int *a, int *b) {
	int cacheIndex = threadIdx.x;
	int i = blockDim.x/2;
	while (i > 0) {
		if (cacheIndex < i) {
			a[blockIdx.x * COLUMNS +cacheIndex] += a[blockIdx.x * COLUMNS + cacheIndex +i];
		}
		__syncthreads();
		i /=2; 
	}
	if (cacheIndex == 0)
		b[blockIdx.x] = a[blockIdx.x * COLUMNS];
		
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
			a[y][x] = x+y;
			sum+= x+y;
		}
	}
	printf("Sum is: %d \n", sum);
	cudaMemcpy(dev_a, a, ROWS*COLUMNS*sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b, b, COLUMNS*sizeof(int), cudaMemcpyHostToDevice);
	
	dim3 thread(COLUMNS,ROWS);
	add<<<8,8>>>(dev_a,dev_b);
	cudaMemcpy(b,dev_b, COLUMNS*sizeof(int),cudaMemcpyDeviceToHost);
	for (int i=0; i<ROWS; i++) {
		cudSum+= b[i];
	} 
	printf("cuda sum is: %d \n", cudSum);

	cudaFree(dev_a);
	cudaFree(dev_b);
	return 0;

}
