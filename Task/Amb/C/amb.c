typedef const char * amb_t;

amb_t amb(size_t argc, ...)
{
  amb_t *choices;
  va_list ap;
  int i;

  if(argc) {
    choices = malloc(argc*sizeof(amb_t));
    va_start(ap, argc);
    i = 0;
    do { choices[i] = va_arg(ap, amb_t); } while(++i < argc);
    va_end(ap);

    i = 0;
    do { TRY(choices[i]); } while(++i < argc);
    free(choices);
  }

  FAIL;
}

int joins(const char *left, const char *right) { return left[strlen(left)-1] == right[0]; }

int _main() {
  const char *w1,*w2,*w3,*w4;

  w1 = amb(3, "the", "that", "a");
  w2 = amb(3, "frog", "elephant", "thing");
  w3 = amb(3, "walked", "treaded", "grows");
  w4 = amb(2, "slowly", "quickly");

  if(!joins(w1, w2)) amb(0);
  if(!joins(w2, w3)) amb(0);
  if(!joins(w3, w4)) amb(0);

  printf("%s %s %s %s\n", w1, w2, w3, w4);

  return EXIT_SUCCESS;
}
