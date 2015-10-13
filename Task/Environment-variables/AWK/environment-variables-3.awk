# http://ideone.com/St5SHF
BEGIN { print "# Environment:"
        for (e in ENVIRON) { printf( "%10s = %s\n", e, ENVIRON[e] ) }
}
END   { print "# Done." }
