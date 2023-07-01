// Untouchable Numbers : Nigel Galloway - March 4th., 2021;
#include <functional>
#include <bitset>
#include <iostream>
#include <cmath>
using namespace std; using Z0=long long; using Z1=optional<Z0>; using Z2=optional<array<int,3>>; using Z3=function<Z2()>;
const int maxUT{3000000}, dL{(int)log2(maxUT)};
struct uT{
  bitset<maxUT+1>N; vector<int> G{}; array<Z3,int(dL+1)>L{Z3{}}; int sG{0},mUT{};
  void _g(int n,int g){if(g<=mUT){N[g]=false; return _g(n,n+g);}}
  Z1 nxt(const int n){if(n>mUT) return Z1{}; if(N[n]) return Z1(n); return nxt(n+1);}
  Z3 fN(const Z0 n,const Z0 i,int g){return [=]()mutable{if(g<sG && ((n+i)*(1+G[g])-n*G[g]<=mUT)) return Z2{{n,i,g++}}; return Z2{};};}
  Z3 fG(Z0 n,Z0 i,const int g){Z0 e{n+i},l{1},p{1}; return [=]()mutable{n=n*G[g]; p=p*G[g]; l=l+p; i=e*l-n; if(i<=mUT) return Z2{{n,i,g}}; return Z2{};};}
  void fL(Z3 n, int g){for(;;){
    if(auto i=n()){N[(*i)[1]]=false; L[g+1]=fN((*i)[0],(*i)[1],(*i)[2]+1); g=g+1; continue;}
    if(auto i=L[g]()){n=fG((*i)[0],(*i)[1],(*i)[2]); continue;}
    if(g>0) if(auto i=L[g-1]()){ g=g-1; n=fG((*i)[0],(*i)[1],(*i)[2]); continue;}
    if(g>0){ n=[](){return Z2{};}; g=g-1; continue;} break;}
  }
  int count(){int g{0}; for(auto n=nxt(0); n; n=nxt(*n+1)) ++g; return g;}
  uT(const int n):mUT{n}{
    N.set(); N[0]=false; N[1]=false; for(auto n=nxt(0);*n<=sqrt(mUT);n=nxt(*n+1)) _g(*n,*n+*n); for(auto n=nxt(0); n; n=nxt(*n+1)) G.push_back(*n); sG=G.size();
    N.set(); N[0]=false; L[0]=fN(1,0,0); fL([](){return Z2{};},0);
  }
};
