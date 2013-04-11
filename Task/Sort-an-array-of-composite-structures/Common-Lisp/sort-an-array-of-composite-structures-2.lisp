CL-USER> (sort (copy-list *test-scores*) #'string-lessp :key #'first)
(("california" 76.2) ("new york" 88.2) ("ohio" 87.8) ("texas" 68.9))
