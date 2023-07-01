#include <stdio.h>
#include <Accelerate/Accelerate.h>

void fft(DSPComplex buf[], int n) {
  float inputMemory[2*n];
  float outputMemory[2*n];
  // half for real and half for complex
  DSPSplitComplex inputSplit = {inputMemory, inputMemory + n};
  DSPSplitComplex outputSplit = {outputMemory, outputMemory + n};

  vDSP_ctoz(buf, 2, &inputSplit, 1, n);

  vDSP_DFT_Setup setup = vDSP_DFT_zop_CreateSetup(NULL, n, vDSP_DFT_FORWARD);

  vDSP_DFT_Execute(setup,
                   inputSplit.realp, inputSplit.imagp,
                   outputSplit.realp, outputSplit.imagp);

  vDSP_ztoc(&outputSplit, 1, buf, 2, n);
}


void show(const char *s, DSPComplex buf[], int n) {
  printf("%s", s);
  for (int i = 0; i < n; i++)
    if (!buf[i].imag)
      printf("%g ", buf[i].real);
    else
      printf("(%g, %g) ", buf[i].real, buf[i].imag);
  printf("\n");
}

int main() {
  DSPComplex buf[] = {{1,0}, {1,0}, {1,0}, {1,0}, {0,0}, {0,0}, {0,0}, {0,0}};

  show("Data: ", buf, 8);
  fft(buf, 8);
  show("FFT : ", buf, 8);

  return 0;
}
