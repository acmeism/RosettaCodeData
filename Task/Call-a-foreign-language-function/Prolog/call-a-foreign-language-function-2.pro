#include <string.h>
#include <stdio.h>
#include <SWI-Prolog.h>

static foreign_t pl_strdup(term_t string0, term_t string1)
{
  char *input_string, *output_string;

  if (PL_get_atom_chars(string0, &input_string))
  {
    output_string = strdup(input_string);
    return PL_unify_atom_chars(string1, output_string);
  }
  PL_fail;
}

install_t install_plffi()
{
  PL_register_foreign("strdup", 2, pl_strdup, 0);
}
