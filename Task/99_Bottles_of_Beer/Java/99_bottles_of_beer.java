import java.text.MessageFormat;
public class Beer
{
 static String bottles(final int n)
 {
  return MessageFormat.format("{0,choice,0#No more bottles|1#One bottle|2#{0} bottles} of beer", n);
 }
 public static void main(final String[] args)
 {
  String byob = bottles(99);
  for (int x = 99; x > 0;)
  {
   System.out.println(byob + " on the wall");
   System.out.println(byob);
   System.out.println("Take one down, pass it around");
   byob = bottles(--x);
   System.out.println(byob + " on the wall\n");
  }
 }
}
