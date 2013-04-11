#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#include <sys/queue.h>

struct entry {
  int value;
  TAILQ_ENTRY(entry) entries;
};

typedef struct entry entry_t;

TAILQ_HEAD(FIFOList_s, entry);

typedef struct FIFOList_s FIFOList;


bool m_enqueue(int v, FIFOList *l)
{
  entry_t *val;
  val = malloc(sizeof(entry_t));
  if ( val != NULL ) {
    val->value = v;
    TAILQ_INSERT_TAIL(l, val, entries);
    return true;
  }
  return false;
}

bool m_dequeue(int *v, FIFOList *l)
{
  entry_t *e = l->tqh_first;
  if ( e != NULL ) {
    *v = e->value;
    TAILQ_REMOVE(l, e, entries);
    free(e);
    return true;
  }
  return false;
}

bool isQueueEmpty(FIFOList *l)
{
  if ( l->tqh_first == NULL ) return true;
  return false;
}
