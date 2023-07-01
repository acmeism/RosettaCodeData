#include <stdio.h>
#include <stdlib.h>

struct list_node {int x; struct list_node *next;};
typedef struct list_node node;

node * uniq(int *a, unsigned alen)
 {if (alen == 0) return NULL;
  node *start = malloc(sizeof(node));
  if (start == NULL) exit(EXIT_FAILURE);
  start->x = a[0];
  start->next = NULL;

  for (int i = 1 ; i < alen ; ++i)
     {node *n = start;
      for (;; n = n->next)
         {if (a[i] == n->x) break;
          if (n->next == NULL)
             {n->next = malloc(sizeof(node));
              n = n->next;
              if (n == NULL) exit(EXIT_FAILURE);
              n->x = a[i];
              n->next = NULL;
              break;}}}

  return start;}

int main(void)
   {int a[] = {1, 2, 1, 4, 5, 2, 15, 1, 3, 4};
    for (node *n = uniq(a, 10) ; n != NULL ; n = n->next)
        printf("%d ", n->x);
    puts("");
    return 0;}
