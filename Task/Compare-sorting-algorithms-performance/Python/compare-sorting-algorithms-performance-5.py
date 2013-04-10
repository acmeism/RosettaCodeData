import collections, itertools, glob, re
import numpy
def plot_timings():
   makedict = lambda: collections.defaultdict(lambda: collections.defaultdict(list))
   df = makedict()
   ds = makedict()
   # populate plot dictionaries
   for filename in glob.glob('*.xy'):
       m = re.match(r'([^-]+)-([^-]+)-(\d+)-(\d+)\.xy', filename)
       print filename
       assert m, filename
       funcname, seqname, npoints, maxN = m.groups()
       npoints, maxN = int(npoints), int(maxN)
       a = numpy.fromiter(itertools.imap(float, open(filename).read().split()), dtype='f')
       Ns = a[::2]  # sequences lengths
       Ts = a[1::2] # corresponding times
       assert len(Ns) == len(Ts) == npoints
       assert max(Ns) <= maxN
       #
       logsafe = numpy.logical_and(Ns>0, Ts>0)
       Ts = numpy.log2(Ts[logsafe])
       Ns = numpy.log2(Ns[logsafe])
       coeffs = numpy.polyfit(Ns, Ts, deg=1)
       poly = numpy.poly1d(coeffs, variable='log2(N)')
       #
       df[npoints][funcname].append((seqname, poly, Ns, Ts))
       ds[npoints][seqname].append((funcname, poly, Ns, Ts))
   # actual plotting
   plotdd(df)
   plotdd(ds) # see ``plotdd()`` above
