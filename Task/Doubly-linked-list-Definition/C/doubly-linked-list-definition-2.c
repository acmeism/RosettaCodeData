/* basic test */

struct IntNode {
  struct MNode node;
  int data;
};

int main()
{
    int i;
    LIST lista;
    struct IntNode *m;
    NODE n;

    lista = newList();
    if ( lista != NULL )
    {
      for(i=0; i < 5; i++)
      {
          m = malloc(sizeof(struct IntNode));
          if ( m != NULL )
          {
             m->data = rand()%64;
             addTail(lista, (NODE)m);
          }
      }
      while( !isEmpty(lista) )
      {
            m = (struct IntNode *)remTail(lista);
            printf("%d\n", m->data);
            free(m);
      }
      free(lista);
    }
}
