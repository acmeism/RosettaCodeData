def maxsubseq(seq):
  return max((seq[begin:end] for begin in xrange(len(seq)+1)
                             for end in xrange(begin, len(seq)+1)),
             key=sum)
