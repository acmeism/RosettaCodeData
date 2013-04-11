int main(){
   array(int|string) collect = ({109, "Hi", "asdf", "qwerty"});
   foreach(collect, int|string elem){
      write(elem + "\n");
   }
}
