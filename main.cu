#include "iostream"

#define N 257

__global__ void sum_of_array(float *arr1, float *arr2, float *arr3) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    arr3[i] = arr1[i] + arr2[i];
}

void initialize_array(float *arr, int size) {
    for (int i = 0; i < size; i++) {
        arr[i] = (float) random();
    }
}

int main() {
    float *arr1, *arr2, *arr3, *d_arr1, *d_arr2, *d_arr3;
    size_t n_byte = N * sizeof(float);

    arr1 = (float *) malloc(n_byte);
    arr2 = (float *) malloc(n_byte);
    arr3 = (float *) malloc(n_byte);

    initialize_array(arr1, N);
    initialize_array(arr2, N);
    initialize_array(arr3, N);

    printf("start cudaMalloc\n");
    cudaMalloc((void **) &d_arr1, N);
    cudaMalloc((void **) &d_arr2, N);
    cudaMalloc((void **) &d_arr3, N);
    printf("finish cudaMalloc\n");

    printf("start cudaMemcpy\n");
    cudaMemcpy(d_arr1, arr1, n_byte, cudaMemcpyHostToDevice);
    cudaMemcpy(d_arr2, arr2, n_byte, cudaMemcpyHostToDevice);
    cudaMemcpy(d_arr3, arr3, n_byte, cudaMemcpyHostToDevice);
    printf("finish cudaMemcpy\n");
    printf("start kernel function\n");
    sum_of_array<<<(N + 255) / 256, 256>>>(d_arr1, d_arr2, d_arr3);
    printf("finish kernel function\n");
    cudaMemcpy(arr3, d_arr3, n_byte, cudaMemcpyDeviceToHost);
    printf("%f", *arr3);

}
