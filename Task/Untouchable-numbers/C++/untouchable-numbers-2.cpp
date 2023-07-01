int main(int argc, char *argv[]) {
  int c{0}; auto n{uT{2000}}; for(auto g=n.nxt(0); g; g=n.nxt(*g+1)){if(c++==30){c=1; printf("\n");} printf("%4d ",*g);} printf("\n");
}
