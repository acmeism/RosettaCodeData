// Rare Numbers : Nigel Galloway - December 20th., 2019;
// Nigel Galloway/Enter your username - January 4th., 2021 (see discussion page.
#include <functional>
#include <bitset>
#include <cmath>
using namespace std;
using Z2 = optional<long long>; using Z1 = function<Z2()>;
// powers of 10 array
constexpr auto pow10 = [] { array <long long, 19> n {1}; for (int j{0}, i{1}; i < 19; j = i++) n[i] = n[j] * 10; return n; } ();
long long acc, l;
bool izRev(int n, unsigned long long i, unsigned long long g) {
  return (i / pow10[n - 1] != g % 10) ? false : n < 2 ? true : izRev(n - 1, i % pow10[n - 1], g / 10);
}
const Z1 fG(Z1 n, int start, int end, int reset, const long long step, long long &l) {
  return [n, i{step * start}, g{step * end}, e{step * reset}, &l, step] () mutable {
    while (i<g){i+=step; return Z2(l+=step);}
    l-=g-(i=e); return n();};
}
struct nLH {
  vector<unsigned long long>even{}, odd{};
  nLH(const Z1 a, const vector<long long> b, long long llim){while (auto i = a()) for (auto ng : b)
    if(ng>0 | *i>llim){unsigned long long sq{ng+ *i}, r{sqrt(sq)}; if (r*r == sq) ng&1 ? odd.push_back(sq) : even.push_back(sq);}}
};
const double fac = 3.94;
const int mbs = (int)sqrt(fac * pow10[9]), mbt = (int)sqrt(fac * fac * pow10[9]) >> 3;
const bitset<100000>bs {[]{bitset<100000>n{false}; for(int g{3};g<mbs;++g) n[(g*g)%100000]=true; return n;}()};
constexpr array<const int,  7>li{1,3,0,0,1,1,1},lin{0,-7,0,0,-8,-3,-9},lig{0,9,0,0,8,7,9},lil{0,2,0,0,2,10,2};
const nLH makeL(const int n){
  constexpr int r{9}; acc=0; Z1 g{[]{return Z2{};}}; int s{-r}, q{(n>11)*5}; vector<long long> w{};
  for (int i{1};i<n/2-q+1;++i){l=pow10[n-i-q]-pow10[i+q-1]; s-=i==n/2-q; g=fG(g,s,r,-r,l,acc+=l*s);}
  if(q){long long g0{0}, g1{0}, g2{0}, g3{0}, g4{0}, l3{pow10[n-5]}; while (g0<7){const long long g{-10000*g4-1000*g3-100*g2-10*g1-g0};
    if (bs[(g+1000000000000LL)%100000]) w.push_back(l3*(g4+g3*10+g2*100+g1*1000+g0*10000)+g);
    if(g4<r) ++g4; else{g4= -r; if(g3<r) ++g3; else{g3= -r; if(g2<r) ++g2; else{g2= -r; if(g1<lig[g0]) g1+=lil[g0]; else {g0+=li[g0];g1=lin[g0];}}}}}}
  return q ? nLH(g,w,0) : nLH(g,{0},0);
}
const bitset<100000>bt {[]{bitset<100000>n{false}; for(int g{11};g<mbt;++g) n[(g*g)%100000]=true; return n;}()};
constexpr array<const int, 17>lu{0,0,0,0,2,0,4,0,0,0,1,4,0,0,0,1,1},lun{0,0,0,0,0,0,1,0,0,0,9,1,0,0,0,1,0},lug{0,0,0,0,18,0,17,0,0,0,9,17,0,0,0,11,18},lul{0,0,0,0,2,0,2,0,0,0,0,2,0,0,0,10,2};
const nLH makeH(const int n){
  acc= -pow10[n>>1]-pow10[(n-1)>>1]; Z1 g{[]{ return Z2{};}}; int q{(n>11)*5}; vector<long long> w {};
  for (int i{1}; i<(n>>1)-q+1; ++i) g = fG(g,0,18,0,pow10[n-i-q]+pow10[i+q-1], acc);
  if (n & 1){l=pow10[n>>1]<<1; g=fG(g,0,9,0,l,acc+=l);}
  if(q){long long g0{4}, g1{0}, g2{0}, g3{0}, g4{0},l3{pow10[n-5]}; while (g0<17){const long long g{g4*10000+g3*1000+g2*100+g1*10+g0};
    if (bt[g%100000]) w.push_back(l3*(g4+g3*10+g2*100+g1*1000+g0*10000)+g);
    if (g4<18) ++g4; else{g4=0; if(g3<18) ++g3; else{g3=0; if(g2<18) ++g2; else{g2=0; if(g1<lug[g0]) g1+=lul[g0]; else{g0+=lu[g0];g1=lun[g0];}}}}}}
  return q ? nLH(g,w,0) : nLH(g,{0},pow10[n-1]<<2);
}
#include <chrono>
using namespace chrono; using VU = vector<unsigned long long>; using VS = vector<string>;
template <typename T> // concatenates vectors
vector<T>& operator +=(vector<T>& v, const vector<T>& w) { v.insert(v.end(), w.begin(), w.end()); return v; }
int c{0}; // solution counter
auto st{steady_clock::now()}, st0{st}, tmp{st}; // for determining elasped time
// formats elasped time
string dFmt(duration<double> et, int digs) {
  string res{""}; double dt{et.count()};
  if (dt > 60.0) { int m = (int)(dt / 60.0); dt -= m * 60.0; res = to_string(m) + "m"; }
  res += to_string(dt); return res.substr(0, digs - 1) + 's';
}
// combines list of square differences with list of square sums, reports compatible results
VS dump(int nd, VU lo, VU hi) {
  VS res {};
  for (auto l : lo) for (auto h : hi) {
    auto r { (h - l) >> 1 }, z { h - r };
    if (izRev(nd, r, z)) {
      char buf[99]; sprintf(buf, "%20llu %11lu %10lu", z, (long long)sqrt(h), (long long)sqrt(l));
      res.push_back(buf); } } return res;
}
// reports one block of digits
void doOne(int n, nLH L, nLH H) {
  VS lines = dump(n, L.even, H.even); lines += dump(n, L.odd , H.odd); sort(lines.begin(), lines.end());
  duration<double> tet = (tmp = steady_clock::now()) - st; int ls = lines.size();
  if (ls-- > 0)
    for (int i{0}; i <= ls; ++i)
      printf("%3d %s%s", ++c, lines[i].c_str(), i == ls ? "" : "\n");
  else printf("%s", string(47, ' ').c_str());
  printf("  %2d:     %s  %s\n", n, dFmt(tmp - st0, 8).c_str(), dFmt(tet, 8).c_str()); st0 = tmp;
}
void Rare(int n) { doOne(n, makeL(n), makeH(n)); }
int main(int argc, char *argv[]) {
  int max{argc > 1 ? stoi(argv[1]) : 19}; if (max < 2) max = 2; if (max > 19 ) max = 19;
  printf("%4s %19s %11s %10s %5s %11s %9s\n", "nth", "forward", "rt.sum", "rt.diff", "digs", "block.et", "total.et");
  for (int nd{2}; nd <= max; ++nd) Rare(nd);
}
