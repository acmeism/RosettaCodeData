int main(){
  N n(4);
  while (n.hasNext()) std::cout << n.next() << "\t* " << std::bitset<4>(n.next()) << std::endl;
}
