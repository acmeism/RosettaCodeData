// Rare Numbers : Nigel Galloway - December 20th., 2019
#include <iostream>
#include <functional>
#include <bitset>
#include <gmpxx.h>
using Z2=std::optional<long>; using Z1=std::function<Z2()>;
constexpr std::array<const long,19> pow10{1,10,100,1000,10000,100000,1000000,10000000,100000000,1000000000,10000000000,100000000000,1000000000000,10000000000000,100000000000000,1000000000000000,10000000000000000,100000000000000000,1000000000000000000};
const bool izRev(const mpz_class n,const mpz_class i,const mpz_class g){return (i/n!=g%10)? false : (n<2)? true : izRev(n/10,i%n,g/10);}
const Z1 fG(Z1 n,int start, int end,int reset,const long step,long &l){return ([n,i{step*start},g{step*end},e{step*reset},&l,step]()mutable{
    while(i<g){l+=step; i+=step; return Z2(l);} i=e; l-=(g-e); return n();});}
struct nLH{
  std::vector<mpz_class>even{};
  std::vector<mpz_class>odd{};
  nLH(std::pair<Z1,std::vector<std::pair<long,long>>> e){auto [n,g]=e; mpz_t w,l,y; mpz_inits(w,l,y,NULL); mpz_set_si(w,pow10[4]);
   while (auto i=n()){for(auto [ng,gg]:g){if((ng>0)|(*i>0)){mpz_set_si(y,gg+*i); mpz_addmul_ui(y,w,ng);
   if(mpz_perfect_square_p(y)) (gg%2==0)? even.push_back(mpz_class(y)) : odd.push_back(mpz_class(y));}}} mpz_clears(w,l,y,NULL);}
};
class Rare{
  mpz_class r,z,p;
  long acc{0};
  const std::bitset<10000>bs;
  const std::pair<Z1,std::vector<std::pair<long,long>>> makeL(const int n){ //std::cout<<"Making L"<<std::endl;
    Z1 g[n/2-3]; g[0]=([]{return Z2{};});
    for(int i{1};i<n/2-3;++i){int s{(i==n/2-4)? -10:-9}; long l=pow10[n-i-4]-pow10[i+3]; acc+=l*s; g[i]=fG(g[i-1],s,9,-9,l,acc);}
    return {g[n/2-4],([g0{0},g1{0},g2{0},g3{0},l3{pow10[n-8]},l2{pow10[n-7]},l1{pow10[n-6]},l0{pow10[n-5]},this]()mutable{std::vector<std::pair<long,long>>w{}; while (g0<10){
      long n{g3*l3+g2*l2+g1*l1+g0*l0}; long g{-1000*g3-100*g2-10*g1-g0}; if(g3<9) ++g3; else{g3=-9; if(g2<9) ++g2; else{g2=-9; if(g1<9) ++g1; else{g1=-9; ++g0;}}}
      if (bs[(pow10[10]+g)%10000]) w.push_back({n,g});} return w;})()};}
  const std::pair<Z1,std::vector<std::pair<long,long>>> makeH(const int n){ acc=-(pow10[n/2]+pow10[(n-1)/2]); //std::cout<<"Making H"<<std::endl;
    Z1 g[(n+1)/2-3]; g[0]=([]{return Z2{};});
    for(int i{1};i<n/2-3;++i) g[i]=fG(g[i-1],(i==(n+1)/2-3)? -1:0,18,0,pow10[n-i-4]+pow10[i+3],acc);
    if(n%2==1) g[(n+1)/2-4]=fG(g[n/2-4],-1,9,0,2*pow10[n/2],acc);
    return {g[(n+1)/2-4],([g0{1},g1{0},g2{0},g3{0},l3{pow10[n-8]},l2{pow10[n-7]},l1{pow10[n-6]},l0{pow10[n-5]},this]()mutable{std::vector<std::pair<long,long>>w{}; while (g0<17){
      long n{g3*l3+g2*l2+g1*l1+g0*l0}; long g{g3*1000+g2*100+g1*10+g0}; if(g3<18) ++g3; else{g3=0; if(g2<18) ++g2; else{g2=0; if(g1<18) ++g1; else{g1=0; ++g0;}}}
      if (bs[g%10000]) w.push_back({n,g});} return w;})()};}
  const nLH L,H;
public: Rare(int n):L{makeL(n)},H{makeH(n)},bs{([]{std::bitset<10000>n{false}; for(int g{0};g<10000;++g) n[(g*g)%10000]=true; return n;})()}{
  mpz_ui_pow_ui(p.get_mpz_t(),10,n-1);
  std::cout<<"Rare "<<n<<std::endl;
  for(auto l:L.even) for(auto h:H.even){r=(h-l)/2; z=h-r; if(izRev(p,r,z)) std::cout<<"n="<<z<<" r="<<r<<" n-r="<<l<<" n+r="<<h<<std::endl;}
  for(auto l:L.odd)  for(auto h:H.odd) {r=(h-l)/2; z=h-r; if(izRev(p,r,z)) std::cout<<"n="<<z<<" r="<<r<<" n-r="<<l<<" n+r="<<h<<std::endl;}
}};
int main(){
  Rare(20);
}
