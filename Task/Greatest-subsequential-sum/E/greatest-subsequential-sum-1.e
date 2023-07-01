pragma.enable("accumulator")

def maxSubseq(seq) {
  def size := seq.size()

  # Collect all intervals of indexes whose values are positive
  def intervals := {
    var intervals := []
    var first := 0
    while (first < size) {
      var next := first
      def seeing := seq[first] > 0
      while (next < size && (seq[next] > 0) == seeing) {
        next += 1
      }
      if (seeing) { # record every positive interval
        intervals with= first..!next
      }
      first := next
    }
    intervals
  }

  # For recording the best result found
  var maxValue := 0
  var maxInterval := 0..!0

  # Try all subsequences beginning and ending with such intervals.
  for firstIntervalIx => firstInterval in intervals {
    for lastInterval in intervals(firstIntervalIx) {
      def interval :=
        (firstInterval.getOptStart())..!(lastInterval.getOptBound())
      def value :=
        accum 0 for i in interval { _ + seq[i] }
      if (value > maxValue) {
        maxValue := value
        maxInterval := interval
      }
    }
  }

  return ["value" => maxValue,
          "indexes" => maxInterval]
}
