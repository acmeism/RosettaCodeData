String toTokenize = "Hello,How,Are,You,Today";

String words[] = toTokenize.split(",");//splits on one comma, multiple commas yield multiple splits
               //toTokenize.split(",+") if you want to ignore empty fields
for(int i=0; i<words.length; i++) {
    System.out.print(words[i] + ".");
}
