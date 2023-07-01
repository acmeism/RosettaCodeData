#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>
#include <glib.h>

#define ROWS   4
#define COLS  10
#define NPRX  "/"

/* wikipedia table
const char *table[ROWS][COLS] =
{
  { "0", "1", "2",  "3", "4", "5", "6",  "7", "8", "9" },
  { "E", "T", NULL, "A", "O", "N", NULL, "R", "I", "S  },
  { "B", "C", "D",  "F", "G", "H", "J",  "K", "L", "M" },
  { "P", "Q", NPRX, "U", "V", "W", "X",  "Y", "Z", "." }
};
*/

/* example of extending the table, COLS must be 11
const char *table[ROWS][COLS] =
{
  { "0", "1", "2", "3",  "4", "5", "6", "7",  "8", "9",  ":"  },
  { "H", "O", "L", NULL, "M", "E", "S", NULL, "R", "T",  ","  },
  { "A", "B", "C", "D",  "F", "G", "I", "J",  "K", "N",  "-"  },
  { "P", "Q", "U", "V",  "W", "X", "Y", "Z",  ".", NPRX, "?"  }
};
*/

// task table
const char *table[ROWS][COLS] =
{
  { "0", "1", "2", "3",  "4", "5", "6", "7",  "8", "9"  },
  { "H", "O", "L", NULL, "M", "E", "S", NULL, "R", "T"  },
  { "A", "B", "C", "D",  "F", "G", "I", "J",  "K", "N"  },
  { "P", "Q", "U", "V",  "W", "X", "Y", "Z",  ".", NPRX }
};


GHashTable *create_table_from_array(const char *table[ROWS][COLS], bool is_encoding)
{
  char buf[16];

  GHashTable *r = g_hash_table_new_full(g_str_hash, g_str_equal, free, free);
  size_t i, j, k, m;

  for(i = 0, m = 0; i < COLS; i++)
  {
    if (table[1][i] == NULL) m++;
  }

  const size_t SELNUM = m;

  size_t selectors[SELNUM];
  size_t numprefix_row, numprefix_col;
  bool has_numprefix = false;

  // selectors keep the indexes of the symbols to select 2nd and 3rd real row;
  // nulls must be placed into the 2nd row of the table
  for(i = 0, k = 0; i < COLS && k < SELNUM; i++)
  {
    if ( table[1][i] == NULL )
    {
      selectors[k] = i;
      k++;
    }
  }

  // numprefix is the prefix to insert symbols from the 1st row of table (numbers)
  for(j = 1; j < ROWS; j++)
  {
    for(i = 0; i < COLS; i++)
    {
      if (table[j][i] == NULL) continue;
      if ( strcmp(table[j][i], NPRX) == 0 )
      {
        numprefix_col = i;
        numprefix_row = j;
        has_numprefix = true;
	break;
      }
    }
  }

  // create the map for each symbol
  for(i = has_numprefix ? 0 : 1; i < ROWS; i++)
  {
    for(j = 0; j < COLS; j++)
    {
      if (table[i][j] == NULL) continue;
      if (strlen(table[i][j]) > 1)
      {
	fprintf(stderr, "symbols must be 1 byte long\n");
	continue; // we continue just ignoring the issue
      }
      if (has_numprefix && i == (ROWS-1) && j == numprefix_col && i == numprefix_row) continue;
      if (has_numprefix && i == 0)
      {
	snprintf(buf, sizeof(buf), "%s%s%s", table[0][selectors[SELNUM-1]], table[0][numprefix_col], table[0][j]);
      }
      else if (i == 1)
      {
	snprintf(buf, sizeof(buf), "%s", table[0][j]);
      }
      else
      {
	snprintf(buf, sizeof(buf), "%s%s", table[0][selectors[i-2]], table[0][j]);
      }
      if (is_encoding) g_hash_table_insert(r, strdup(table[i][j]), strdup(buf));
      else g_hash_table_insert(r, strdup(buf), strdup(table[i][j]));
    }
  }
  if (is_encoding) g_hash_table_insert(r, strdup("mode"), strdup("encode"));
  else g_hash_table_insert(r, strdup("mode"), strdup("decode"));

  return r;
}

char *decode(GHashTable *et, const char *enctext)
{
  char *r = NULL;

  if (et == NULL || enctext == NULL || strlen(enctext) == 0 ||
      g_hash_table_lookup(et, "mode") == NULL ||
      strcmp(g_hash_table_lookup(et, "mode"), "decode") != 0) return NULL;

  GString *res = g_string_new(NULL);
  GString *en = g_string_new(NULL);

  for( ; *enctext != '\0'; enctext++ )
  {
    if (en->len < 3)
    {
      g_string_append_c(en, *enctext);
      r = g_hash_table_lookup(et, en->str);
      if (r == NULL) continue;
      g_string_append(res, r);
      g_string_truncate(en, 0);
    }
    else
    {
      fprintf(stderr, "decoding error\n");
      break;
    }
  }

  r = res->str;
  g_string_free(res, FALSE);
  g_string_free(en, TRUE);
  return r;
}

char *encode(GHashTable *et, const char *plaintext, int (*trasf)(int), bool compress_spaces)
{
  GString *s;
  char *r = NULL;
  char buf[2] = { 0 };

  if (plaintext == NULL ||
      et == NULL || g_hash_table_lookup(et, "mode") == NULL ||
      strcmp(g_hash_table_lookup(et, "mode"), "encode") != 0) return NULL;

  s = g_string_new(NULL);

  for(buf[0] = trasf ? trasf(*plaintext) : *plaintext;
      buf[0] != '\0';
      buf[0] = trasf ? trasf(*++plaintext) : *++plaintext)
  {
    if ( (r = g_hash_table_lookup(et, buf)) != NULL )
    {
      g_string_append(s, r);
    }
    else if (isspace(buf[0]))
    {
      if (!compress_spaces) g_string_append(s, buf);
    }
    else
    {
      fprintf(stderr, "char '%s' is not encodable%s\n",
	      isprint(buf[0]) ? buf : "?",
	      !compress_spaces ? ", replacing with a space" : "");
      if (!compress_spaces) g_string_append_c(s, ' ');
    }
  }

  r = s->str;
  g_string_free(s, FALSE);
  return r;
}


int main()
{
  GHashTable *enctab = create_table_from_array(table, true);  // is encoding? true
  GHashTable *dectab = create_table_from_array(table, false); // is encoding? false (decoding)

  const char *text = "One night-it was on the twentieth of March, 1888-I was returning";

  char *encoded = encode(enctab, text, toupper, true);
  printf("%s\n", encoded);

  char *decoded = decode(dectab, encoded);
  printf("%s\n", decoded);

  free(decoded);
  free(encoded);
  g_hash_table_destroy(enctab);
  g_hash_table_destroy(dectab);

  return 0;
}
