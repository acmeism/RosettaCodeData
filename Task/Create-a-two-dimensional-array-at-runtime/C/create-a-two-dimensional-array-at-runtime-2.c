/*
  assume this file is c.c ,
  compile and run on linux: cc -Wall -g -DCOMPILE_EXAMPLE c.c -lm -o c && ./c
*/

#include<stdlib.h>
#include<stdio.h>

static void error(int status, char*message) {
  fprintf(stderr,"\n%s\n",message);
  exit(status);
}

static void*dwlcalloc(int n,size_t bytes) {
  void*rv = (void*)calloc(n,bytes);
  if (NULL == rv)
    error(1, "memory allocation failure");
  return rv;
}

void*allocarray(size_t rank,size_t*shape,size_t itemSize) {
  /*
     Allocates arbitrary dimensional arrays (and inits all pointers)
     with only 1 call to malloc.  Lambert Electronics, USA, NY.
     This is wonderful because one only need call free once to deallocate
     the space.  Special routines for each size array are not need for
     allocation of for deallocation.  Also calls to malloc might be expensive
     because they might have to place operating system requests.  One call
     seems optimal.
  */
  size_t size,i,j,dataSpace,pointerSpace,pointers,nextLevelIncrement;
  char*memory,*pc,*nextpc;
  if (rank < 2) {
    if (rank < 0)
      error(1,"invalid negative rank argument passed to allocarray");
    size = rank < 1 ? 1 : *shape;
    return dwlcalloc(size,itemSize);
  }
  pointerSpace = 0, dataSpace = 1;
  for (i = 0; i < rank-1; ++i)
    pointerSpace += (dataSpace *= shape[i]);
  pointerSpace *= sizeof(char*);
  dataSpace *= shape[i]*itemSize;
  memory = pc = dwlcalloc(1,pointerSpace+dataSpace);
  pointers = 1;
  for (i = 0; i < rank-2; ) {
    nextpc = pc + (pointers *= shape[i])*sizeof(char*);
    nextLevelIncrement = shape[++i]*sizeof(char*);
    for (j = 0; j < pointers; ++j)
      *((char**)pc) = nextpc, pc+=sizeof(char*), nextpc += nextLevelIncrement;
  }
  nextpc = pc + (pointers *= shape[i])*sizeof(char*);
  nextLevelIncrement = shape[++i]*itemSize;
  for (j = 0; j < pointers; ++j)
    *((char**)pc) = nextpc, pc+=sizeof(char*), nextpc += nextLevelIncrement;
  return memory;
}

#ifdef COMPILE_EXAMPLE

#include<string.h>
#include<math.h>

#define Z 5
#define Y 10
#define X 39

#define BIND(A,L,H) ((L)<(A)?(A)<(H)?(A):(H):(L))

void p_char(void*pv) {
  char s[3];
  int i = 0;
  s[i++] = ' ', s[i++] = *(char*)pv, s[i++] = 0;
  fputs(s, stdout);
}

void display(void*a,size_t rank,size_t*shape,void(*f)(void*)) {
  int i;
  if (0 == rank)
    (*f)(a);
  else if (1 == rank) {
    for (i = 0; i < *shape; ++i)
      (*f)(a+i);
    putchar('\n');
  } else {
    for (i = 0; i < *shape; ++i)
      display(((void**)a)[i], rank-1, shape+1, f);
    putchar('\n');
  }
}

int main() {			/* character cell 3D graphics.  Whoot */
  char***array;
  float x,y,z;
  size_t rank, shape[3], i, j, k;
  rank = 0;
  shape[rank++] = Z, shape[rank++] = Y, shape[rank++] = X;
  array = allocarray(rank, shape, sizeof(char));
  memset(**array, ' ', X*Y*Z*(sizeof(***array))); /* load the array with spaces */
  for (i = 0; i < X; ++i) {
    x = i/(float)X;
    for (j = 0; j < Y; ++j) {
      y = j/(float)X;
      z = x*y*(4*M_PI);
      z = 5.2*(0.5+(0.276765 - sin(z)*cos(z)*exp(1-z))/0.844087); /* a somewhat carefully designed silly function */
      /* printf("%g %g %g\n", x, y, z); */
      k = (int)z;
      array[BIND(k, 0, Z-1)][j][i] = '@'; /* BIND ensures a valid index  */
    }
  }
  display(array, rank, shape, p_char);
  puts("\nIt is what it is.");
  free(array);
  return EXIT_SUCCESS;
}
#endif
