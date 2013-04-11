/* stack_trace.c - macros for hinting/tracing where a program crashed
                   on a system _without_ any form of debugger.

Simple goodbye_cruel_world.c example:

#include <stdio.h>
#include <stdlib.h>

#define STACK_TRACE_ON // compile in these "stack_trace" routines
#include "stack_trace.h"

void goodbye_cruel_world()
BEGIN(goodbye_cruel_world)
  print_stack_trace();
  for(;;){}
END

int main()
BEGIN(main)
  stack_trace.on = TRUE; // turn on runtime tracing
  goodbye_cruel_world();
  stack_trace.on = FALSE;
  RETURN(EXIT_SUCCESS);
END

Output:
goodbye_cruel_world.c:8: BEGIN goodbye_cruel_world[0x80486a8], stack(depth:1, size:60)
goodbye_cruel_world.c:8:        goodbye_cruel_world[0x80486a8]  --- stack(depth:2, size:60) ---
goodbye_cruel_world.c:14:       main[0x80486f4] --- stack(depth:1, size:0) ---
goodbye_cruel_world.c:8:   --- (depth 2) ---

*/
#ifndef _LINUX_STDDEF_H
#include <stddef.h>
#endif

typedef struct stack_trace_frame_s {
  const char *file_name;
  int file_line;
  const char *proc_name;
  void *proc_addr;
  struct stack_trace_frame_s *down, *up;
} stack_trace_frame_t;

#define SKIP
typedef enum {TRUE=1, FALSE=0} bool_t;

typedef struct {
  bool_t on;
  struct { const char *_begin, *_print, *_return, *_exit, *_end; } fmt;
  struct { int depth; stack_trace_frame_t *lwb, *upb; } stack;
  struct { int lwb, by, upb; const char *prefix; } indent;
} stack_trace_t;

extern stack_trace_t stack_trace;

void stack_trace_begin(char *SKIP, stack_trace_frame_t *SKIP);
void stack_trace_end(char *SKIP, int SKIP);
void print_stack_trace();


#ifdef STACK_TRACE_ON

/* Many ThanX to Steve R Bourne for inspiring the following macros ;-) */
#define BEGIN(x) { auto stack_trace_frame_t this = {__FILE__, __LINE__, #x, &x, NULL, NULL}; \
                  stack_trace_begin(stack_trace.fmt._begin, &this); {
#define RETURN(x) { stack_trace_end(stack_trace.fmt._return, __LINE__); return(x); }
#define EXIT(x)   { stack_trace_end(stack_trace.fmt._exit, __LINE__); exit(x); }
#define END }       stack_trace_end(stack_trace.fmt._end, __LINE__); }

#else

/* Apologies to Landon Curt Noll and Larry Bassel for the following macros :-) */
#define BEGIN(x) {
#define RETURN(x) return(x)
#define EXIT(x) exit(x)
#define END }

#endif
