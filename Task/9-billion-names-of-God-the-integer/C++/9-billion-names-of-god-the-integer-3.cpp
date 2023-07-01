int main(){
  N = 25;
  std::cout << std::setw(N+52) << "1" << std::endl;
  std::cout << std::setw(N+55) << "1     1" << std::endl;
  std::cout << std::setw(N+58) << "1     1     1" << std::endl;
  std::string ott[N-3];
  for (int n=1; n<N/2; n++) {
    G_hyp(n);
    for (int g=(n-1)*2; g<N-3; g++) {
      std::string t = hyp[g-(n-1)].get_str();
      //if (t.size()==1) t.insert(t.begin(),1,' ');
      ott[g].append(t);
      ott[g].append(6-t.size(),' ');
    }
  }
  for(int n = 0; n<N-3; n++) {
    std::cout <<std::setw(N+43-3*n) << 1 << "     " << ott[n];
    for (int g = (n+1)/2; g>0; g--) {
      std::string t{hyp[g-1].get_str()};
      t.append(6-t.size(),' ');
      std::cout << t;
    }
    std::cout << "1     1" << std::endl;
  }
