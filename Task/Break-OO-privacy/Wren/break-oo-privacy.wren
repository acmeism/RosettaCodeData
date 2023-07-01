class Safe {
    construct new() { _safe = 42 } // the field _safe is private
    safe { _safe }                 // provides public access to field
    doubleSafe { notSoSafe_ }      // another public method
    notSoSafe_ { _safe * 2 }       // intended only for private use but still accesible externally
}

var s = Safe.new()
var a = [s.safe, s.doubleSafe, s.notSoSafe_]
for (e in a) System.print(e)
