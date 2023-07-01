pragma.enable("accumulator")

def [amb, unamb] := { # block hides internals

  def Choice := Tuple[any, Map]

  def [ambS, ambU] := <elib:sealing.makeBrand>("amb")
  var counter := 0 # Used just for printing ambs

  /** Check whether two sets of decisions are consistent */
  def consistent(decA, decB) {
    def overlap := decA.domain() & decB.domain()
    for ambObj in overlap {
      if (decA[ambObj] != decB[ambObj]) { return false }
    }
    return true
  }

  /** From an amb object, extract the possible choices */
  def getChoices(obj, decisions) :List[Choice] {
    if (decisions.maps(obj)) {
      return [[decisions[obj], decisions]]
    } else if (ambU.amplify(obj) =~ [[choices, _]]) {
      return accum [] for [chosen, dec] ? (consistent(decisions, dec)) in choices { _ + getChoices(chosen, (decisions | dec).with(obj, chosen)) }
    } else {
      return [[obj, decisions]]
    }
  }

  /** Construct an amb object with remembered decisions */
  def ambDec(choices :List[Choice]) {
    def serial := (counter += 1)
    def ambObj {
      to __printOn(out) {
        out.print("<amb(", serial, ")")
        for [chosen, decisions] in choices {
          out.print(" ", chosen)
          for k => v in decisions {
            out.print(";", ambU.amplify(k)[0][1], "=", v)
          }
        }
        out.print(">")
      }
      to __optSealedDispatch(brand) {
        if (brand == ambS.getBrand()) {
          return ambS.seal([choices, serial])
        }
      }
      match [verb, args] {
        var results := []
        for [rec, rdec] in getChoices(ambObj, [].asMap()) {
          def expandArgs(dec, prefix, choosing) {
            switch (choosing) {
               match [] { results with= [E.call(rec, verb, prefix), dec] }
               match [argAmb] + moreArgs {
                 for [arg, adec] in getChoices(argAmb, dec) {
                   expandArgs(adec, prefix.with(arg), moreArgs)
                 }
               }
            }
          }
          expandArgs(rdec, [], args)
        }
        ambDec(results)
      }
    }
    return ambObj
  }

  /** Construct an amb object with no remembered decisions. (public interface) */
  def amb(choices) {
    return ambDec(accum [] for c in choices { _.with([c, [].asMap()]) })
  }

  /** Get the possible results from an amb object, discarding decision info. (public interface) */
  def unamb(ambObj) {
    return accum [] for [c,_] in getChoices(ambObj, [].asMap()) { _.with(c) }
  }

  [amb, unamb]
}
