def makeType(label, superstamps) {
    def stamp {
        to audit(audition) {
            for s in superstamps { audition.ask(s) }
            return true
        }
    }
    def guard {
        to coerce(specimen, ejector) {
            if (__auditedBy(stamp, specimen)) {
                return specimen
            } else {
                throw.eject(ejector, `$specimen is not a $label`)
            }
        }
    }
    return [guard, stamp]
}
