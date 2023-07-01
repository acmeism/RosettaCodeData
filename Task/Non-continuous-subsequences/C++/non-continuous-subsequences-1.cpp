/*
 * Nigel Galloway, July 19th., 2017 - Yes well is this any better?
 */
class N{
  uint n,i,g,e,l;
public:
  N(uint n): n(n-1),i{},g{},e(1),l(n-1){}
  bool hasNext(){
    g=(1<<n)+e;for(i=l;i<n;++i) g+=1<<i;
    if (l==2)             {l=--n; e=1; return true;}
    if (e<((1<<(l-1))-1)) {++e;        return true;}
                           e=1; --l;   return (l>0);
  }
  uint next() {return g;}
};
