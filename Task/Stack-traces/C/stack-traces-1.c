#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <execinfo.h>

#define MAX_BT 200

void print_stack_trace()
{
  void *buffer[MAX_BT];
  int n;

  n = backtrace(buffer, MAX_BT);
  fprintf(stderr, "--- (depth %d) ---\n", n);
  backtrace_symbols_fd(buffer, n, STDERR_FILENO);
}


void inner(int k)
{
  print_stack_trace();
}

void middle(int x, int y)
{
  inner(x*y);
}

void outer(int a, int b, int c)
{
  middle(a+b, b+c);
}

int main()
{
  outer(2,3,5);
  return EXIT_SUCCESS;
}
