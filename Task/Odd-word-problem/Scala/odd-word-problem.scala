import scala.io.Source
import java.io.PrintStream

def process(s: Source, p: PrintStream, w: Int = 0): Unit = if (s.hasNext) s.next match {
  case '.' => p append '.'
  case c if !Character.isAlphabetic(c) => p append c; reverse(s, p, w + 1)
  case c => p append c; process(s, p, w)
}

def reverse(s: Source, p: PrintStream, w: Int = 0, x: Char = '.'): Char = s.next match {
  case c if !Character.isAlphabetic(c) => p append x; c
  case c => val n = reverse(s, p, w, c);
    if (x == '.') {p append n; process(s, p, w + 1)} else p append x; n
}

process(Source.fromString("what,is,the;meaning,of:life."), System.out); println
process(Source.fromString("we,are;not,in,kansas;any,more."), System.out); println
