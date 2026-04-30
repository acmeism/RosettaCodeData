(directory-files "/some/dir/name"
                 nil        ;; just the filenames, not full paths
                 "\\.c\\'"  ;; regexp
                 t)         ;; don't sort the filenames
;;=> ("foo.c" "bar.c" ...)
