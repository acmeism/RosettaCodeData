def minherit(self, supers) {
    def forwarder match [verb, args] {
        escape __return {
            if (verb == "__respondsTo") {
                def [verb, arity] := args
                for super ? (super.__respondsTo(verb, arity)) in supers {
                    return true
                }
                return false
            } else if (verb == "__getAllegedType") {
                # XXX not a complete implementation
                return supers[0].__getAllegedType()
            } else {
                def arity := args.size()
                for super ? (super.__respondsTo(verb, arity)) in supers {
                    return E.call(super, verb, args)
                }
                throw(`No parent of $self responds to $verb/$arity`)
            }
        }
    }
    return forwarder
}
