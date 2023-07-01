define int_to_bin(d)
{
  variable m = 0x40000000, prn = 0, bs = "";
  do {
    if (d & m) {
      bs += "1";
      prn = 1;
    }
    else if (prn)
      bs += "0";
    m = m shr 1;

  } while (m);

  if (bs == "") bs = "0";
  return bs;
}

() = printf("%s\n", int_to_bin(5));
() = printf("%s\n", int_to_bin(50));
() = printf("%s\n", int_to_bin(9000));
