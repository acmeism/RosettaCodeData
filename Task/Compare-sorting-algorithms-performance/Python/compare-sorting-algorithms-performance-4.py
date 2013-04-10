import operator
import numpy, pylab
def plotdd(dictplotdict):
   """See ``plot_timings()`` below."""
   symbols = ('o', '^', 'v', '<', '>', 's', '+', 'x', 'D', 'd',
              '1', '2', '3', '4', 'h', 'H', 'p', '|', '_')
   colors = list('bgrcmyk') # split string on distinct characters
   for npoints, plotdict in dictplotdict.iteritems():
       for ttle, lst in plotdict.iteritems():
           pylab.hold(False)
           for i, (label, polynom, x, y) in enumerate(sorted(lst,key=operator.itemgetter(0))):
               pylab.plot(x, y, colors[i % len(colors)] + symbols[i % len(symbols)], label='%s %s' % (polynom, label))
               pylab.hold(True)
               y = numpy.polyval(polynom, x)
               pylab.plot(x, y, colors[i % len(colors)], label= '_nolegend_')
           pylab.legend(loc='upper left')
           pylab.xlabel(polynom.variable)
           pylab.ylabel('log2( time in microseconds )')
           pylab.title(ttle, verticalalignment='bottom')
           figname = '_%(npoints)03d%(ttle)s' % vars()
           pylab.savefig(figname+'.png')
           pylab.savefig(figname+'.pdf')
           print figname
