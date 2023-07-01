int func()
{
  int ints[NMEMB]; /* it resembles malloc ... */
  int *int2;       /* here the only thing allocated on the stack is a pointer */
  char intstack[SIZEOF_MEMB*NMEMB]; /* to show resemblance to malloc */
  int2 = (int *)intstack;           /* but this is educative, do not do so unless... */

  {
    const char *pointers_to_char[NMEMB];
    /* use pointers_to_char */
    pointers_to_char[0] = "educative";
  } /* outside the block, the variable "disappears" */

  /* here we can use ints, int2, intstack vars, which are not seen elsewhere of course */

  return 0;
}
