#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

typedef enum type
{
  INT,
  STRING
} Type;

typedef struct maybe
{
  int i;
  char *s;
  Type t;
  _Bool is_something;
} Maybe;

void print_Maybe(Maybe *m)
{
  if (m->t == INT)
    printf("Just %d : INT\n", m->i);

  else if (m->t == STRING)
    printf("Just \"%s\" : STRING\n", m->s);

  else
    printf("Nothing\n");

}

Maybe *return_maybe(void *data, Type t)
{
  Maybe *m = malloc(sizeof(Maybe));
  if (t == INT)
  {
    m->i = *(int *) data;
    m->s = NULL;
    m->t = INT;
    m->is_something = true;
  }

  else if (t == STRING)
  {
    m->i = 0;
    m->s = data;
    m->t = STRING;
    m->is_something = true;
  }

  else
  {
    m->i = 0;
    m->s = NULL;
    m->t = 0;
    m->is_something = false;
  }

  return m;
}

Maybe *bind_maybe(Maybe *m, Maybe *(*f)(void *))
{
  Maybe *n = malloc(sizeof(Maybe));

  if (f(&(m->i))->is_something)
  {
    n->i = f(&(m->i))->i;
    n->s = f(&(m->i))->s;
    n->t = f(&(m->i))->t;
    n->is_something = true;
  }

  else
  {
    n->i = 0;
    n->s = NULL;
    n->t = 0;
    n->is_something = false;
  }
  return n;
}

Maybe *f_1(void *v) // Int -> Maybe Int
{
  Maybe *m = malloc(sizeof(Maybe));
  m->i = (*(int *) v) * (*(int *) v);
  m->s = NULL;
  m->t = INT;
  m->is_something = true;
  return m;
}

Maybe *f_2(void *v) // :: Int -> Maybe String
{
  Maybe *m = malloc(sizeof(Maybe));
  m->i = 0;
  m->s = malloc(*(int *) v * sizeof(char) + 1);
  for (int i = 0; i < *(int *) v; i++)
  {
    m->s[i] = 'x';
  }
  m->s[*(int *) v + 1] = '\0';
  m->t = STRING;
  m->is_something = true;
  return m;
}

int main()
{
  int i = 7;
  char *s = "lorem ipsum dolor sit amet";

  Maybe *m_1 = return_maybe(&i, INT);
  Maybe *m_2 = return_maybe(s, STRING);

  print_Maybe(m_1); // print value of m_1: Just 49
  print_Maybe(m_2); // print value of m_2 : Just "lorem ipsum dolor sit amet"

  print_Maybe(bind_maybe(m_1, f_1)); // m_1 `bind` f_1 :: Maybe Int
  print_Maybe(bind_maybe(m_1, f_2)); // m_1 `bind` f_2 :: Maybe String

  print_Maybe(bind_maybe(bind_maybe(m_1, f_1), f_2)); // (m_1 `bind` f_1) `bind` f_2 :: Maybe String -- it prints 49 'x' characters in a row
}
