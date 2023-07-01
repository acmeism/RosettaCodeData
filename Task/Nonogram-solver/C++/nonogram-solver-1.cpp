// A class to solve Nonogram (Hadje) Puzzles
// Nigel Galloway - January 23rd., 2017
template<uint _N, uint _G> class Nonogram {
  enum class ng_val : char {X='#',B='.',V='?'};
  template<uint _NG> struct N {
    N() {}
    N(std::vector<int> ni,const int l) : X{},B{},Tx{},Tb{},ng(ni),En{},gNG(l){}
    std::bitset<_NG> X, B, T, Tx, Tb;
    std::vector<int> ng;
    int En, gNG;
    void        fn (const int n,const int i,const int g,const int e,const int l){
      if (fe(g,l,false) and fe(g+l,e,true)){
      if ((n+1) < ng.size()) {if (fe(g+e+l,1,false)) fn(n+1,i-e-1,g+e+l+1,ng[n+1],0);}
      else {
        if (fe(g+e+l,gNG-(g+e+l),false)){Tb &= T.flip(); Tx &= T.flip(); ++En;}
      }}
      if (l<=gNG-g-i-1) fn(n,i,g,e,l+1);
    }
    void        fi (const int n,const bool g) {X.set(n,g); B.set(n, not g);}
    ng_val      fg (const int n) const{return (X.test(n))? ng_val::X : (B.test(n))? ng_val::B : ng_val::V;}
    inline bool fe (const int n,const int i, const bool g){
      for (int e = n;e<n+i;++e) if ((g and fg(e)==ng_val::B) or (!g and fg(e)==ng_val::X)) return false; else T[e] = g;
      return true;
    }
    int         fl (){
      if (En == 1) return 1;
      Tx.set(); Tb.set(); En=0;
      fn(0,std::accumulate(ng.cbegin(),ng.cend(),0)+ng.size()-1,0,ng[0],0);
      return En;
    }}; // end of N
  std::vector<N<_G>> ng;
  std::vector<N<_N>> gn;
  int En, zN, zG;
  void setCell(uint n, uint i, bool g){ng[n].fi(i,g); gn[i].fi(n,g);}
public:
  Nonogram(const std::vector<std::vector<int>>& n,const std::vector<std::vector<int>>& i,const std::vector<std::string>& g = {}) : ng{}, gn{}, En{}, zN(n.size()), zG(i.size()) {
    for (int n=0; n<zG; n++) gn.push_back(N<_N>(i[n],zN));
    for (int i=0; i<zN; i++) {
      ng.push_back(N<_G>(n[i],zG));
      if (i < g.size()) for(int e=0; e<zG or e<g[i].size(); e++) if (g[i][e]=='#') setCell(i,e,true);
    }}
  bool solve(){
    int i{}, g{};
    for (int l = 0; l<zN; l++) {
      if ((g = ng[l].fl()) == 0) return false; else i+=g;
      for (int i = 0; i<zG; i++) if (ng[l].Tx[i] != ng[l].Tb[i]) setCell (l,i,ng[l].Tx[i]);
    }
    for (int l = 0; l<zG; l++) {
      if ((g = gn[l].fl()) == 0) return false; else i+=g;
      for (int i = 0; i<zN; i++) if (gn[l].Tx[i] != gn[l].Tb[i]) setCell (i,l,gn[l].Tx[i]);
    }
    if (i == En)    return false; else En = i;
    if (i == zN+zG) return true;  else return solve();
  }
  const std::string toStr() const {
    std::ostringstream n;
    for (int i = 0; i<zN; i++){for (int g = 0; g<zG; g++){n << static_cast<char>(ng[i].fg(g));}n<<std::endl;}
    return n.str();
  }};
