#define cSize( a )  ( sizeof(a)/sizeof(a[0]) ) /* a.size() */
int ar[10];               /* Collection<Integer> ar = new ArrayList<Integer>(10); */
ar[0] = 1;                /* ar.set(0, 1); */
ar[1] = 2;

int* p;                   /* Iterator<Integer> p; Integer pValue; */
for (p=ar;                /* for( p = ar.itereator(), pValue=p.next(); */
       p<(ar+cSize(ar));  /*        p.hasNext(); */
       p++) {             /*        pValue=p.next() ) { */
  printf("%d\n",*p);      /*   System.out.println(pValue); */
}                         /* } */
