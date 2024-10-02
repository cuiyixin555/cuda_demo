// MIT License

// Copyright (c) 2024 CUI Xin

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "main.h"

/**
 * @brief  Error Handling
 * @param err error status code
 */
inline void checkCudaErrors(cudaError err) {
  if (cudaSuccess != err) {
    fprintf(stderr, "CUDA Runtime API error: %s.\n", cudaGetErrorString(err));
    return;
  }
}

/**
 * @brief CUDA Kernel Function
 *
 * @param a
 * @param b
 * @param c
 */
__global__ void add(int *a, int *b, int *c) {
  int tid = blockIdx.x * blockDim.x + threadIdx.x;
  for (size_t k = 0; k < 50000; k++) {
    c[tid] = a[tid] + b[tid];
  }
}

/**
 * @brief adding token extern "C" for function runtest due to its called by
 * main.cpp
 *
 * @param a
 * @param b
 * @param c
 */
extern "C" int runtest(int *host_a, int *host_b, int *host_c) {
  int *dev_a, *dev_b, *dev_c;

  /// allocate cuda gpu memory
  checkCudaErrors(cudaMalloc((void **)&dev_a, sizeof(int) * datasize));
  checkCudaErrors(cudaMalloc((void **)&dev_b, sizeof(int) * datasize));
  checkCudaErrors(cudaMalloc((void **)&dev_c, sizeof(int) * datasize));

  /// data blocks in host are copied to device
  checkCudaErrors(cudaMemcpy(dev_a, host_a, sizeof(int) * datasize,
                             cudaMemcpyHostToDevice));
  checkCudaErrors(cudaMemcpy(dev_b, host_b, sizeof(int) * datasize,
                             cudaMemcpyHostToDevice));

  /// deal with data by GPU
  add<<<datasize / 100, 100>>>(dev_a, dev_b, dev_c);
  /// data in device write back to host
  checkCudaErrors(cudaMemcpy(host_c, dev_c, sizeof(int) * datasize,
                             cudaMemcpyDeviceToHost));

  /// clear gpu memory
  cudaFree(dev_a);
  cudaFree(dev_b);
  cudaFree(dev_c);
  return 0;
}