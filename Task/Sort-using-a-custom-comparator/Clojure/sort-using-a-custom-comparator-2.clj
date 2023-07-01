(sort-by (juxt (comp - count) #(.toLowerCase %))
         ["Here" "are" "some" "sample" "strings" "to" "be" "sorted"])
