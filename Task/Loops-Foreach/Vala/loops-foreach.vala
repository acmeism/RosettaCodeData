List<string> things = new List<string> ();
things.append("Apple");
things.append("Banana");
things.append("Coconut");

foreach (string thing in things)
{
  stdout.printf("%s\n", thing);
}
