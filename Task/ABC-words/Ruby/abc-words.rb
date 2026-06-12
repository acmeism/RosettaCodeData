puts File.open("unixdict.txt").grep(/^[^bc]*a[^c]*b.*c/)
