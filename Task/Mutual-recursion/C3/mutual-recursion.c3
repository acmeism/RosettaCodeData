module rosettacode;

import std::io;

fn int f(int n)
{
  return (n == 0) ? 1 : n - m(f(n-1));
}

fn int m(int n)
{
  return (n == 0) ? 0 : n - f(m(n-1));
}

fn int main(String[] args)
{
  for(int i = 0; i < 20; i++) io::printf("%2d ",f(i));
  io::printn();
  for(int i = 0; i < 20; i++) io::printf("%2d ",m(i));
  io::printn();
	return 0;
}
