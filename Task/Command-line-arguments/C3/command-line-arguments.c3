import std::io;

fn void main(String[] args)
{
  io::printfn("This program is named %s.", args[0]);
  for (int i = 1; i < args.len; i++)
  {
    io::printfn("the argument #%d is %s\n", i, args[i]);
  }
}
