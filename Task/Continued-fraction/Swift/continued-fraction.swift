extension BinaryInteger {
  @inlinable
  public func power(_ n: Self) -> Self {
    return stride(from: 0, to: n, by: 1).lazy.map({_ in self }).reduce(1, *)
  }
}

public struct CycledSequence<WrappedSequence: Sequence> {
  private var seq: WrappedSequence
  private var iter: WrappedSequence.Iterator

  init(seq: WrappedSequence) {
    self.seq = seq
    self.iter = seq.makeIterator()
  }
}

extension CycledSequence: Sequence, IteratorProtocol {
  public mutating func next() -> WrappedSequence.Element? {
    if let ele = iter.next() {
      return ele
    } else {
      iter = seq.makeIterator()

      return iter.next()
    }
  }
}

extension Sequence {
  public func cycled() -> CycledSequence<Self> {
    return CycledSequence(seq: self)
  }
}

public struct ChainedSequence<Element> {
  private var sequences: [AnySequence<Element>]
  private var iter: AnyIterator<Element>
  private var curSeq = 0

  init(chain: ChainedSequence) {
    self.sequences = chain.sequences
    self.iter = chain.iter
    self.curSeq = chain.curSeq
  }

  init<Seq: Sequence>(_ seq: Seq) where Seq.Element == Element {
    sequences = [AnySequence(seq)]
    iter = sequences[curSeq].makeIterator()
  }

  func chained<Seq: Sequence>(with seq: Seq) -> ChainedSequence where Seq.Element == Element {
    var res = ChainedSequence(chain: self)

    res.sequences.append(AnySequence(seq))

    return res
  }
}

extension ChainedSequence: Sequence, IteratorProtocol {
  public mutating func next() -> Element? {
    if let el = iter.next() {
      return el
    }

    curSeq += 1

    guard curSeq != sequences.endIndex else {
      return nil
    }

    iter = sequences[curSeq].makeIterator()

    return iter.next()
  }
}

extension Sequence {
  public func chained<Seq: Sequence>(with other: Seq) -> ChainedSequence<Element> where Seq.Element == Element {
    return ChainedSequence(self).chained(with: other)
  }
}

func continuedFraction<T: Sequence, V: Sequence>(
  _ seq1: T,
  _ seq2: V,
  iterations: Int = 1000
) -> Double where T.Element: BinaryInteger, T.Element == V.Element {
  return zip(seq1, seq2).prefix(iterations).reversed().reduce(0.0, { Double($1.0) + (Double($1.1) / $0) })
}

let sqrtA = [1].chained(with: [2].cycled())
let sqrtB = [1].cycled()

print("√2 ≈ \(continuedFraction(sqrtA, sqrtB))")

let napierA = [2].chained(with: 1...)
let napierB = [1].chained(with: 1...)

print("e ≈ \(continuedFraction(napierA, napierB))")

let piA = [3].chained(with: [6].cycled())
let piB = (1...).lazy.map({ (2 * $0 - 1).power(2) })

print("π ≈ \(continuedFraction(piA, piB))")
