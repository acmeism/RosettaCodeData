#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
  typedef enum State { READY, WAITING, REFUND, DISPENSE, COLLECT, QUIT } State;

  typedef struct statechange {
    const int in;
    const State out;
  } statechange;

#define MAXINPUTS 3
  typedef struct FSM {
    const State state;
    void (*Action)(void);
    const statechange table[MAXINPUTS]; // would be nice if could be [] ...
  } FSM;

  char str[10];
  void Ready(void)    { fprintf(stderr, "\nMachine is READY. (D)eposit or (Q)uit :"); scanf("%s", str); }
  void Waiting(void)  { fprintf(stderr, "(S)elect product or choose to (R)efund :"); scanf("%s", str); }
  void Refund(void)   { fprintf(stderr, "Please collect refund.\n"); }
  void Dispense(void) { fprintf(stderr, "Dispensing product...\n"); }
  void Collect(void)  { fprintf(stderr, "Please (C)ollect product. :"); scanf("%s", str); }
  void Quit(void)     { fprintf(stderr, "Thank you, shutting down now.\n"); exit(0); }

  const FSM fsm[] = {
    { READY,    &Ready,    {{'D', WAITING},  {'Q', QUIT },    {-1, READY}    }},
    { WAITING,  &Waiting,  {{'S', DISPENSE}, {'R', REFUND},   {-1, WAITING}  }},
    { REFUND,   &Refund,   {{ -1, READY}                                     }},
    { DISPENSE, &Dispense, {{ -1, COLLECT}                                   }},
    { COLLECT,  &Collect,  {{'C', READY},    { -1, COLLECT }                 }},
    { QUIT,     &Quit,     {{ -1, QUIT}                                      }},
  };

  int each;
  State state = READY;

  for (;;) {
    fsm[state].Action();
    each = 0;
    while (!( ((fsm[state].table[each].in == -1)
               // -1 comes last and is catchall: exit, or loop to self, on no valid input.
               || (isalpha(str[0]) && fsm[state].table[each].in == toupper(str[0]) )))) each++;
    state = fsm[state].table[each].out;
  }

  return 0;
}
