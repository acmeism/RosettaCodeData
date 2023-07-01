// For the purpose of this task I provide a little code to read from a file in the required format
// Note though that Nonograms may contain blank lines and values greater than 24
int main(){
  std::ifstream n ("nono.txt");
  if (!n) {
    std::cerr << "Unable to open nono.txt.\n";
    exit(EXIT_FAILURE);
  }
  std::string i;
  getline(n,i);
  std::istringstream g(i);
  std::string e;
  std::vector<std::vector<int>> N;
    while (g >> e) {
      std::vector<int> G;
      for (char l : e) G.push_back((int)l-64);
      N.push_back(G);
    }
  getline(n,i);
  std::istringstream gy(i);
  std::vector<std::vector<int>> G;
    while (gy >> e) {
      std::vector<int> N;
      for (char l : e) N.push_back((int)l-64);
      G.push_back(N);
    }
  Nonogram<32,32> myN(N,G);
  if (!myN.solve()) std::cout << "I don't believe that this is a nonogram!" << std::endl;
  std::cout << "\n" << myN.toStr() << std::endl;
}
