#include "common/book.h"

__global__ void add(int *a, int *b, int *c, int N){
	int tid = blockIdx.x;
	if(tid<N){
		c[tid] = a[tid] + b[tid];
	} 
}

int main(void){
	for (int N = 1000;N<=10000;N+=1000){
		// 기존: int a[N], b[N], c[N];
		int *a = (int *)malloc(N * sizeof(int));
		int *b = (int *)malloc(N * sizeof(int));
		int *c = (int *)malloc(N * sizeof(int));
		int threadsPerBlock = 256;
		int blocksPerGrid = (N + threadsPerBlock - 1) / threadsPerBlock;
		int *dev_a, *dev_b, *dev_c;
		HANDLE_ERROR(cudaMalloc((void**)&dev_a, N * sizeof(int)));
		HANDLE_ERROR(cudaMalloc((void**)&dev_b, N * sizeof(int)));
		HANDLE_ERROR(cudaMalloc((void**)&dev_c, N * sizeof(int)));
		for (int i = 0; i < N; i++){
			a[i] = -i;
			b[i] = i * i;
		}
		HANDLE_ERROR(cudaMemcpy(dev_a, a, N * sizeof(int), cudaMemcpyHostToDevice));
		HANDLE_ERROR(cudaMemcpy(dev_b, b, N * sizeof(int), cudaMemcpyHostToDevice));
		clock_t start = clock();
		add<<<N,1>>>(dev_a, dev_b, dev_c, N);
		clock_t end = clock();
		printf("소요 시간 : %lf\n", (double)(end - start) / CLOCKS_PER_SEC);
		HANDLE_ERROR(cudaMemcpy(c, dev_c, N * sizeof(int), cudaMemcpyHostToDevice));
		for(int i = 0; i<N;i++){
			//printf("%d + %d = %d \n", a[i], b[i], c[i]);
		}
		HANDLE_ERROR(cudaFree(dev_a));
		HANDLE_ERROR(cudaFree(dev_b));
		HANDLE_ERROR(cudaFree(dev_c));
		free(a); free(b); free(c);
	}
	return 0;
}
