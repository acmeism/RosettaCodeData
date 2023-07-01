#include <stdio.h>
#include <stddef.h>

#define STACK_TRACE_ON
#include "stack_trace.h"

#define indent_fmt "%s"
#define std_cc_diag_fmt "%s:%d: "
#define stack_trace_diag_fmt " %s[0x%x], stack(depth:%d, size:%u)\n"
#define stack_trace_fmt "%s:%d:\t%s[0x%x]\t--- stack(depth:%d, size:%u) ---\n"

stack_trace_t stack_trace  = {
    FALSE, /* default: stack_trace.on == FALSE */
    { std_cc_diag_fmt""indent_fmt"BEGIN"stack_trace_diag_fmt,
      stack_trace_fmt,
      std_cc_diag_fmt""indent_fmt"RETURN"stack_trace_diag_fmt,
      std_cc_diag_fmt""indent_fmt"EXIT"stack_trace_diag_fmt,
      std_cc_diag_fmt""indent_fmt"END"stack_trace_diag_fmt },
    { 0, (stack_trace_frame_t*)NULL, (stack_trace_frame_t*)NULL }, /* stack */
    { 19, 2, 20, "                   " } /* indent wrap */
  };

void stack_trace_begin(const char *fmt, stack_trace_frame_t *this){
  if(stack_trace.on){
    fprintf(stderr, fmt,
      this->file_name, this->file_line,  /* file details */
      stack_trace.indent.prefix+stack_trace.indent.lwb,
      this->proc_name, this->proc_addr,  /* procedure details */
      stack_trace.stack.depth, (unsigned)stack_trace.stack.lwb-(unsigned)this);
    stack_trace.indent.lwb =
        ( stack_trace.indent.lwb - stack_trace.indent.by ) % stack_trace.indent.upb;
  }

  if(!stack_trace.stack.upb){ /* this IS the stack !! */
    stack_trace.stack.lwb = stack_trace.stack.upb = this;
  } else {
    this -> down = stack_trace.stack.upb;
    stack_trace.stack.upb -> up = this;
    stack_trace.stack.upb = this;
  }
  stack_trace.stack.depth++;
}

void stack_trace_end(const char *fmt, int line){
  stack_trace.stack.depth--;
  if(stack_trace.on){
    stack_trace.indent.lwb =
        ( stack_trace.indent.lwb + stack_trace.indent.by ) % stack_trace.indent.upb;
    stack_trace_frame_t *this = stack_trace.stack.upb;
    fprintf(stderr, fmt,
      this->file_name, this->file_line,  /* file details */
      stack_trace.indent.prefix+stack_trace.indent.lwb,
      this->proc_name, this->proc_addr,  /* procedure details */
      stack_trace.stack.depth, (unsigned)stack_trace.stack.lwb-(unsigned)this);
  }
  stack_trace.stack.upb = stack_trace.stack.upb -> down;
}

void print_indent(){
  if(!stack_trace.stack.upb){
    /* fprintf(stderr, "STACK_TRACE_ON not #defined during compilation\n"); */
  } else {
    stack_trace_frame_t *this = stack_trace.stack.upb;
    fprintf(stderr, std_cc_diag_fmt""indent_fmt,
      this->file_name, this->file_line,  /* file details */
      stack_trace.indent.prefix+stack_trace.indent.lwb
    );
  }
}

void print_stack_trace() {
  if(!stack_trace.stack.upb){
    /* fprintf(stderr, "STACK_TRACE_ON not #defined during compilation\n"); */
  } else {
    int depth = stack_trace.stack.depth;
    stack_trace_frame_t *this = stack_trace.stack.upb;
    for(this = stack_trace.stack.upb; this; this = this->down, depth--){
      fprintf(stderr, stack_trace.fmt._print,
        this->file_name, this->file_line,  /* file details */
        this->proc_name, this->proc_addr,  /* procedure details */
        depth, (unsigned)stack_trace.stack.lwb-(unsigned)this);
    }
    print_indent(); fprintf(stderr, "--- (depth %d) ---\n", stack_trace.stack.depth);
  }
}
