foreach testcase {
    "~/{Downloads,Pictures}/*.{jpg,gif,png}"
    "It{{em,alic}iz,erat}e{d,}, please."
    "{,{,gotta have{ ,\\, again\\, }}more }cowbell!"
    "\{\}\} some \}\{,\{\\\\\{ edge, edge\} \\,\}\{ cases, \{here\} \\\\\\\\\\\}"
} {
    puts $testcase\n\t[join [commatize $testcase] \n\t]
}
