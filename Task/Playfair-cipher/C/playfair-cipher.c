/* Playfair cipher */

#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define MAX_LENGTH 256
#define MAX_RESULT_LENGTH 3*MAX_LENGTH
/* including chars separating duplicate letters and spaces separating digrams */
#define FALSE 0
#define TRUE -1

typedef int bool;

enum Playfair_option {NO_Q, I_EQUALS_J};

struct Playfair
{
  enum Playfair_option pfo; /* Set this before calling fill_table */
  char table[5][5];
};

struct position
{
  unsigned int row, col;
};

void fill_table(struct Playfair *pl, char *keyword)
{
  bool used[26];
  unsigned int i, j, k;
  char alphabet[53]; /* Assume that keyword has at most 26 chars. */
  for (i = 0; i <= 25; i++)
    used[i] = FALSE;
  if (pl->pfo == NO_Q)
    used['Q' - 'A'] = TRUE;
  else
    used['J' - 'A'] = TRUE;
  strcpy(alphabet, keyword);
  strcat(alphabet, "ABCDEFGHIJKLMNOPQRSTUVWXYZ");
  i = 0;
  j = 0;
  k = 0;
  char c;
  while ((c = toupper(alphabet[k])) != '\0')
  {
    if (c >= 'A' && c <= 'Z')
    {
      if (!used[c - 'A'])
      {
        pl->table[i][j] = c;
        used[c - 'A'] = TRUE;
        j++;
        if (j == 5)
        {
          i++;
          if (i == 5)
            return; /* filled */
          j = 0;
        }
      }
    }
    k++;
  }
}

void get_clean_text(char *result, char *plain_text, enum Playfair_option opt)
{
  char prev_char = '\0', next_char;
  unsigned int i, j;
  i = 0;
  j = 0; /* Number of chars in result */
  while (plain_text[i] != '\0')
  {
    next_char = toupper(plain_text[i]);
    if (next_char >= 'A' && next_char <= 'Z' &&
        (next_char != 'Q' || opt != NO_Q))
    {
      if (next_char == 'J' && opt == I_EQUALS_J)
        next_char = 'I';
      /* Insert X between duplicate letters
         Assume that X is not duplicated. */
      if (next_char == prev_char)
        result[j++] = 'X';
      result[j++] = next_char;
      prev_char = next_char;
    }
    i++;
  }
  /* If necessary, add another letter to complete digram */
  if (j % 2 == 1)
  {
    if (result[j - 1] != 'X')
      result[j++] = 'X';
    else
      result[j++] = 'Z';
  }
  result[j] = '\0';
}

struct position find_char(struct Playfair pl, char c)
{
  struct position pos;
  unsigned int i, j;
  for (i = 0; i < 5; i++)
    for (j = 0; j < 5; j++)
      if (pl.table[i][j] == c)
      {
        pos.row = i;
        pos.col = j;
        return pos;
      }
  /* Not found */
  pos.row = 5;
  pos.col = 5;
  return pos;
}

void encode(char *result, struct Playfair pl, char *plain_text)
{
  char clean_text[MAX_LENGTH];
  get_clean_text(clean_text, plain_text, pl.pfo);
  unsigned int length = strlen(clean_text), i, j;
  j = 0;
  for (i = 0; i < length; i += 2)
  {
    struct position pos1, pos2;
    pos1 = find_char(pl, clean_text[i]);
    pos2 = find_char(pl, clean_text[i + 1]);
    if (pos1.row == pos2.row)
    {
      result[j]     = pl.table[pos1.row][pos1.col % 5 + 1];
      result[j + 1] = pl.table[pos2.row][pos2.col % 5 + 1];
    }
    else if (pos1.col == pos2.col)
    {
      result[j]     = pl.table[pos1.row % 5 + 1][pos1.col];
      result[j + 1] = pl.table[pos2.row % 5 + 1][pos2.col];
    }
    else
    {
      result[j]     = pl.table[pos1.row][pos2.col];
      result[j + 1] = pl.table[pos2.row][pos1.col];
    }
    j += 2;
    result[j++] = ' ';
  }
  result[j] = '\0';
}

void decode(char *result, struct Playfair pl, char *cipher_text)
{
  unsigned int length = strlen(cipher_text), i;
  for (i = 0; i < length; i += 3)
  {
    /* cipher_text will include spaces, so we need to skip them */
    struct position pos1, pos2;
    pos1 = find_char(pl, cipher_text[i]);
    pos2 = find_char(pl, cipher_text[i + 1]);
    if (pos1.row == pos2.row)
    {
      result[i]     = pl.table[pos1.row][pos1.col > 0 ? pos1.col - 1 : 4];
      result[i + 1] = pl.table[pos2.row][pos2.col > 0 ? pos2.col - 1 : 4];
    }
    else if (pos1.col == pos2.col)
    {
      result[i]     = pl.table[pos1.row > 0 ? pos1.row - 1 : 4][pos1.col];
      result[i + 1] = pl.table[pos2.row > 0 ? pos2.row - 1 : 4][pos2.col];
    }
    else
    {
      result[i]     = pl.table[pos1.row][pos2.col];
      result[i + 1] = pl.table[pos2.row][pos1.col];
    }
    result[i + 2] = ' ';
  }
  result[length] = '\0';
}

void demo(char *keyword, enum Playfair_option opt, char *plain_text)
{
  char encoded_text[MAX_RESULT_LENGTH], decoded_text[MAX_RESULT_LENGTH];
  struct Playfair pl;
  unsigned int i, j;
  printf("Playfair keyword: %s\n", keyword);
  pl.pfo = opt;
  if (pl.pfo == NO_Q)
    printf("Ignored");
  else
    printf("Regarded");
  printf(" Q when filling the table.\n");
  printf("The table is: \n\n");
  fill_table(&pl, keyword);
  for (i = 0; i < 5; i++)
  {
    for (j = 0; j < 5; j++)
      printf("%c ", pl.table[i][j]);
    printf("\n");
  }
  printf("\n");
  printf("Plain text is  : %s\n", plain_text);
  encode(encoded_text, pl, plain_text);
  printf("Encoded text is: %s\n", encoded_text);
  decode(decoded_text, pl, encoded_text);
  printf("Decoded text is: %s\n\n", decoded_text);
}

int main()
{
  demo("Playfair example", I_EQUALS_J, "Hide the gold in...the TREESTUMP!!!!");
}
