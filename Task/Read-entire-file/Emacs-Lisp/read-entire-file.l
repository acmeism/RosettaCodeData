(setq my-variable (with-temp-buffer
                    (insert-file-contents "foo.txt")
                    (buffer-string)))
