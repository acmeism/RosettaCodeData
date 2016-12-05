func fibonacci() -> SequenceOf<UInt> {
  return SequenceOf {() -> GeneratorOf<UInt> in
    var window: (UInt, UInt, UInt) = (0, 0, 1)
    return GeneratorOf {
      window = (window.1, window.2, window.1 + window.2)
      return window.0
    }
  }
}
