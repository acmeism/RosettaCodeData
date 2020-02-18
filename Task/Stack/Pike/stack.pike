object s = ADT.Stack();
s->push("a");
s->push("b");
write("top: %O, pop1: %O, pop2: %O\n",
      s->top(), s->pop(), s->pop());
s->reset(); // Empty the stack
