//requires C99
#define ITERATE_LIST(n, list) \
 for(Node *n = (list)->head; n; n = n->next)

...
ITERATE_LIST(n, list)
{
    printf("node value: %s\n", n->value);
}
