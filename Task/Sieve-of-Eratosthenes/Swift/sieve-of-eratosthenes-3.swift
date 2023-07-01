import Foundation

func soeTreeFoldingOdds() -> UnfoldSequence<Int, (Int?, Bool)> {
  class CIS<T> {
    let head: T
    let rest: (() -> CIS<T>)
    init(_ hd: T, _ rst: @escaping (() -> CIS<T>)) {
      self.head = hd; self.rest = rst
    }
  }

  func merge(_ xs: CIS<Int>, _ ys: CIS<Int>) -> CIS<Int> {
    let x = xs.head; let y = ys.head
    if x < y { return CIS(x, {() in merge(xs.rest(), ys) }) }
    else { if y < x { return CIS(y, {() in merge(xs, ys.rest()) }) }
    else { return CIS(x, {() in merge(xs.rest(), ys.rest()) }) } }
  }

  func smults(_ p: Int) -> CIS<Int> {
    let inc = p + p
    func smlts(_ c: Int) -> CIS<Int> {
      return CIS(c, { () in smlts(c + inc) })
    }
    return smlts(p * p)
  }

  func allmults(_ ps: CIS<Int>) -> CIS<CIS<Int>> {
    return CIS(smults(ps.head), { () in allmults(ps.rest()) })
  }

  func pairs(_ css: CIS<CIS<Int>>) -> CIS<CIS<Int>> {
    let cs0 = css.head; let ncss = css.rest()
    return CIS(merge(cs0, ncss.head), { () in pairs(ncss.rest()) })
  }

  func cmpsts(_ css: CIS<CIS<Int>>) -> CIS<Int> {
    let cs0 = css.head
    return CIS(cs0.head, { () in merge(cs0.rest(), cmpsts(pairs(css.rest()))) })
  }

  func minusAt(_ n: Int, _ cs: CIS<Int>) -> CIS<Int> {
    var nn = n; var ncs = cs
    while nn >= ncs.head { nn += 2; ncs = ncs.rest() }
    return CIS(nn, { () in minusAt(nn + 2, ncs) })
  }

  func oddprms() -> CIS<Int> {
    return CIS(3, { () in minusAt(5, cmpsts(allmults(oddprms()))) })
  }

  var odds = oddprms()
  return sequence(first: 2, next: { _ in
    let p = odds.head; odds = odds.rest()
    return p
  })
}

let range = 100000000

print("The primes up to 100 are:")
soeTreeFoldingOdds().prefix(while: { $0 <= 100 })
  .forEach { print($0, "", terminator: "") }
print()

print("Found \(soeTreeFoldingOdds().lazy.prefix(while: { $0 <= 1000000 })
                .reduce(0) { (a, _) in a + 1 }) primes to 1000000.")

let start = NSDate()
let answr = soeTreeFoldingOdds().prefix(while: { $0 <= range })
              .reduce(0) { (a, _) in a + 1 }
let elpsd = -start.timeIntervalSinceNow

print("Found \(answr) primes to \(range).")

print(String(format: "This test took %.3f milliseconds.", elpsd * 1000))
