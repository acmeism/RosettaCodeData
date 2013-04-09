int* ar;                  /* Collection<Integer> ar; */
int arSize;
arSize = (rand() % 6) + 1;
ar = calloc(arSize, sizeof(int) ); /* ar = new ArrayList<Integer>(arSize); */
ar[0] = 1;                /* ar.set(0, 1); */

int* p;                   /* Iterator<Integer> p; Integer pValue; */
for (p=ar;                /* p=ar.itereator(); for( pValue=p.next(); */
       p<(ar+arSize);     /*                         p.hasNext(); */
       p++) {             /*                         pValue=p.next() ) { */
  printf("%d\n",*p);      /*   System.out.println(pValue); */
}                         /* }    */
