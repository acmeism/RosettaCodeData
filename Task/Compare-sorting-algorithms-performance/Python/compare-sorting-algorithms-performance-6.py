sort_functions = [
    builtinsort,         # see implementation above
    insertion_sort,      # see [[Insertion sort]]
    insertion_sort_lowb, # ''insertion_sort'', where sequential search is replaced
                         #     by lower_bound() function
    qsort,               # see [[Quicksort]]
    qsortranlc,          # ''qsort'' with randomly choosen ''pivot''
                         #     and the filtering via list comprehension
    qsortranpart,        # ''qsortranlc'' with filtering via ''partition'' function
    qsortranpartis,      # ''qsortranpart'', where for a small input sequence lengths
    ]                    #     ''insertion_sort'' is called
if __name__=="__main__":
   import sys
   sys.setrecursionlimit(10000)
   write_timings(npoints=100, maxN=1024, # 1 <= N <= 2**10 an input sequence length
                 sort_functions=sort_functions,
                 sequence_creators = (ones, range, shuffledrange))
   plot_timings()
