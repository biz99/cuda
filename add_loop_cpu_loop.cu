#include "common/book.h"
void add(int *a, int *b, int *c, int N){
	int tid = 0;
	while(tid < N){
		c[tid] = a[tid] + b[tid];
		tid += 1;
	}
}

int main(void){
	for (int N=1000;N<=10000;N+=1000){
		int a[N] , b[N], c[N];
		for (int i = 0; i < N; i++){
			a[i] = -i;
			b[i] = i * i;
		}

		clock_t start = clock();

		add ( a, b, c, N);
		clock_t end = clock();

		printf("소요 시간 : %lf\n", (double)(end - start) / CLOCKS_PER_SEC);
		for(int i = 0; i < N ; i++){
			//printf( "%d + %d = %d \n", a[i], b[i], c[i]);
		}
	}
	return 0;
}
