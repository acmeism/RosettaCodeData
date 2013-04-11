int main(){
   for(int i = 99; i > 0; i--){
      write(i + " bottles of beer on the wall, " + i + " bottles of beer.\n");
      write("Take one down and pass it around, " + (i-1) + " bottles of beer on the wall.\n\n");
   }
   write("No more bottles of beer on the wall, no more bottles of beer.\n");
   write("Go to the store and buy some more, 99 bottles of beer on the wall.\n");
}
