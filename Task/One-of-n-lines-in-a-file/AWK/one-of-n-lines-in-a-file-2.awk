for i in `seq 1 10000`; do seq 1 10 | awk -v Seed=$RANDOM -f one_of_n_lines_in_a_file.awk; done |sort|uniq -c
