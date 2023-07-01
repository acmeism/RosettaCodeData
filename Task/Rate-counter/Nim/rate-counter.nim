import sugar, std/monotimes, times

type Func[T] = (T) -> T

func cube(n: int): int = n * n * n

proc benchmark[T](n: int; f: Func[T]; arg: T): seq[Duration] =
  result.setLen(n)
  for i in 0..<n:
    let m = getMonoTime()
    discard f(arg)
    result[i] = getMonoTime() - m

echo "Timings (nanoseconds):"
for time in benchmark(10, cube, 5):
  echo time.inNanoseconds
