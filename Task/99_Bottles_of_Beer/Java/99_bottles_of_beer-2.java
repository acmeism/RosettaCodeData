public class Beer
{
 public static void main(final String[] args)
 {
  int beer = 99;
  StringBuilder sb = new StringBuilder();
  String data[] = new String[] { " bottles of beer on the wall\n",
                                 " bottles of beer.\nTake one down, pass it around,\n",
                                 "Better go to the store and buy some more." };

  while (beer > 0)
   sb.append(beer).append(data[0]).append(beer).append(data[1]).append(--beer).append(data[0]).append("\n");

  System.out.println(sb.append(data[2]).toString());
 }
}
