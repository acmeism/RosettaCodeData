/** The following closure creates a list of n evenly-spaced points around the unit circle,
  * useful in FFT calculations, among other things */
def rootsOfUnity = { n ->
    (0..<n).collect {
        Complex.fromPolar(1, 2 * Math.PI * it / n)
    }
}
