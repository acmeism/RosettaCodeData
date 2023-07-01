$ perl -e "warn -t STDOUT ? 'Terminal' : 'Other'"
Terminal
$ perl -e "warn -t STDOUT ? 'Terminal' : 'Other'" > x.tmp
Other
