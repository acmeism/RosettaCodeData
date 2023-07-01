def expandRanges = { compressed ->
    Eval.me('['+compressed.replaceAll(~/(\d)-/, '$1..')+']').flatten().toString()[1..-2]
}
