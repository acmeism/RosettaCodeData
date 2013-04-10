def write_timings(npoints=10, maxN=10**4, sort_functions=(builtinsort,insertion_sort, qsort),
                  sequence_creators = (ones, range, shuffledrange)):
   Ns = range(2, maxN, maxN//npoints)
   for sort in sort_functions:
       for make_seq in sequence_creators:
           Ts = [usec(sort, (make_seq(n),)) for n in Ns]
           writedat('%s-%s-%d-%d.xy' % (sort.__name__,  make_seq.__name__, len(Ns), max(Ns)), Ns, Ts)
