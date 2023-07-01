CL-USER> (sort (copy-list *test-scores*) #'< :key #'second)
(("texas" 68.9) ("california" 76.2) ("ohio" 87.8) ("new york" 88.2))
