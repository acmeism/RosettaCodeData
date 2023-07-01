filter_and_last( generate;
                 map(.value) | @tsv;
                 "", "Counts:", (map(.count) | @tsv ))
