echo "`cat f | paste -sd+ | bc -l` / `cat f | wc -l`" | bc -l
