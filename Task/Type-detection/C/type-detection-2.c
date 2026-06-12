#include <stdio.h>
#include <stdbool.h>
#include <assert.h>

typedef enum {
  STRING,
  INPUT_FILE
} tag_t;

typedef struct {
  tag_t tag;
  union {
    char *string;
    FILE *input_file;
  } value;
} source_t;

void
print_text (source_t source)
{
  switch (source.tag)
    {
    case STRING:
      fputs (source.value.string, stdout);
      break;
    case INPUT_FILE:
      {
        int c;
        c = getc (source.value.input_file);
        while (c != EOF)
          {
            putc (c, stdout);
            c = getc (source.value.input_file);
          }
      }
      break;
    default:
      assert (false);
    }
}

int
main ()
{
  source_t source;

  source.tag = STRING;
  source.value.string = "This\nis a\ntext.\n";
  print_text (source);

  source.tag = INPUT_FILE;
  source.value.input_file = fopen ("type_detection-c.c", "r");
  print_text (source);
}
