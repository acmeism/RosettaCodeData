public class Doors
{
 public static void main(final String[] args)
 {
  StringBuilder sb = new StringBuilder();

  for (int i = 1; i <= 10; i++)
   sb.append("Door #").append(i*i).append(" is open\n");

  System.out.println(sb.toString());
 }
}
