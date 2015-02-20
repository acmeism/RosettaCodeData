String toTokenize = "Hello,How,Are,You,Today";

StringTokenizer tokenizer = new StringTokenizer(toTokenize, ",");
while(tokenizer.hasMoreTokens()) {
    System.out.print(tokenizer.nextToken() + ".");
}
