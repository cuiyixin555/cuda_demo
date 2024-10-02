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

#include "main.h"

/**
 * @brief add extern "C" token to call runtest in cu files
 *
 */
extern "C" int runtest(int *host_a, int *host_b, int *host_c);

int main() {
  int a[datasize], b[datasize], c[datasize];
  for (size_t i = 0; i < datasize; i++) {
    a[i] = i;
    b[i] = i * i;
  }

  /// save image processing start time onn GPU
  long now1 = clock();
  /// call gpu to accelerate
  runtest(a, b, c);
  /// output gpu processing time
  printf("GPU运行时间为: %dms\n",
         int(((double)(clock() - now1)) / CLOCKS_PER_SEC * 1000));

  /// save image processing start time on CPU
  long now2 = clock();
  for (size_t i = 0; i < datasize; i++) {
    for (size_t k = 0; k < 50000; k++) {
      c[i] = (a[i] + b[i]);
    }
  }
  /// output cpu processing time
  printf("CPU运行时间为: %dms\n",
         int(((double)(clock() - now2)) / CLOCKS_PER_SEC * 1000));

  /// showing result
  for (size_t i = 0; i < 100; i++) {
    printf("%d+%d=%d\n", a[i], b[i], c[i]);
  }

  getchar();
  return 0;
}