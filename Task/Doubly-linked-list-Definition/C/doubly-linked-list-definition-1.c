/* double linked list */
#include <stdio.h>
#include <stdlib.h>

struct List {
   struct MNode *head;
   struct MNode *tail;
   struct MNode *tail_pred;
};

struct MNode {
   struct MNode *succ;
   struct MNode *pred;
};

typedef struct MNode *NODE;
typedef struct List *LIST;

/*
** LIST l = newList()
** create (alloc space for) and initialize a list
*/
LIST newList(void);

/*
** int isEmpty(LIST l)
** test if a list is empty
*/
int isEmpty(LIST);

/*
** NODE n = getTail(LIST l)
** get the tail node of the list, without removing it
*/
NODE getTail(LIST);

/*
** NODE n = getHead(LIST l)
** get the head node of the list, without removing it
*/
NODE getHead(LIST);

/*
** NODE rn = addTail(LIST l, NODE n)
** add the node n to the tail of the list l, and return it (rn==n)
*/
NODE addTail(LIST, NODE);

/*
** NODE rn = addHead(LIST l, NODE n)
** add the node n to the head of the list l, and return it (rn==n)
*/
NODE addHead(LIST, NODE);

/*
** NODE n = remHead(LIST l)
** remove the head node of the list and return it
*/
NODE remHead(LIST);

/*
** NODE n = remTail(LIST l)
** remove the tail node of the list and return it
*/
NODE remTail(LIST);

/*
** NODE rn = insertAfter(LIST l, NODE r, NODE n)
** insert the node n after the node r, in the list l; return n (rn==n)
*/
NODE insertAfter(LIST, NODE, NODE);

/*
** NODE rn = removeNode(LIST l, NODE n)
** remove the node n (that must be in the list l) from the list and return it (rn==n)
*/
NODE removeNode(LIST, NODE);


LIST newList(void)
{
    LIST tl = malloc(sizeof(struct List));
    if ( tl != NULL )
    {
       tl->tail_pred = (NODE)&tl->head;
       tl->tail = NULL;
       tl->head = (NODE)&tl->tail;
       return tl;
    }
    return NULL;
}

int isEmpty(LIST l)
{
   return (l->head->succ == 0);
}

NODE getHead(LIST l)
{
  return l->head;
}

NODE getTail(LIST l)
{
  return l->tail_pred;
}


NODE addTail(LIST l, NODE n)
{
    n->succ = (NODE)&l->tail;
    n->pred = l->tail_pred;
    l->tail_pred->succ = n;
    l->tail_pred = n;
    return n;
}

NODE addHead(LIST l, NODE n)
{
    n->succ = l->head;
    n->pred = (NODE)&l->head;
    l->head->pred = n;
    l->head = n;
    return n;
}

NODE remHead(LIST l)
{
   NODE h;
   h = l->head;
   l->head = l->head->succ;
   l->head->pred = (NODE)&l->head;
   return h;
}

NODE remTail(LIST l)
{
   NODE t;
   t = l->tail_pred;
   l->tail_pred = l->tail_pred->pred;
   l->tail_pred->succ = (NODE)&l->tail;
   return t;
}

NODE insertAfter(LIST l, NODE r, NODE n)
{
   n->pred = r; n->succ = r->succ;
   n->succ->pred = n; r->succ = n;
   return n;
}

NODE removeNode(LIST l, NODE n)
{
   n->pred->succ = n->succ;
   n->succ->pred = n->pred;
   return n;
}
