(let ((hostname (extensions:lookup-host-entry "www.rosettacode.org")))
                (print (map 'list #'extensions:ip-string (host-entry-addr-list hostname))))
("71.19.147.227")
