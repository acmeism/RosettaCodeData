# an infinite stateful iterator with unknown typed elements
Base.IteratorSize(::MyIterator) = Base.IsInfinite()
Base.isdone(::MyIterator, _ = nothing) = false
Base.IteratorEltype(::MyIterator) = Base.EltypeUnknown()
