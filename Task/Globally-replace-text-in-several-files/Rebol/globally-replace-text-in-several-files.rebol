foreach file [%a.txt %b.txt %c.txt][
    ;; For each filename in the list...
    write file                       ;; Overwrite the file with the modified contents
        replace/all                  ;; Replace all occurrences of the target substring
            read file                ;; Read current file content
            "Goodbye London!"        ;; Search for this substring
            "Hello New York!"        ;; Replace it with this new substring
]
