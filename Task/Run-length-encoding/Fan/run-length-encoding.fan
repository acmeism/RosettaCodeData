**
** Generates a run-length encoding for a string
**
class RLE
{
  Run[] encode(Str s)
  {
    runs := Run[,]

    s.size.times |i|
    {
      ch := s[i]
      if (runs.size==0 || runs.last.char != ch)
        runs.add(Run(ch))
      runs.last.inc
    }
    return runs
  }

  Str decode(Run[] runs)
  {
    buf := StrBuf()
    runs.each |run|
    {
      run.count.times { buf.add(run.char.toChar) }
    }
    return buf.toStr
  }

  Void main()
  {
    echo(decode(encode(
"WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW"
        )))
  }

}

internal class Run
{
  Int char
  Int count := 0
  new make(Int ch) { char = ch }
  Void inc() { ++count }

  override Str toStr() { return "${count}${char.toChar}" }
}
