public class Doors
{
 public static void main(final String[] args)
 {
  boolean[] doors = new boolean[100];

  for (int pass = 0; pass < 10; pass++)
   doors[(pass + 1) * (pass + 1) - 1] = true;

  for(int i = 0; i < 100; i++)
   System.out.println("Door #" + (i + 1) + " is " + (doors[i] ? "open." : "closed."));
 }
}
