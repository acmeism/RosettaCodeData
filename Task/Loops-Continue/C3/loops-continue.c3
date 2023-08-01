for (int i = 1; i <= 10; i++)
{
   io::print(i);
   if (i % 5 == 0)
   {
      io::printn();
      continue;
   }
   io::print(", ");
}
