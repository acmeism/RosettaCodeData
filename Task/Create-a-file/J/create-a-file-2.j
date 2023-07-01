require 'files'
NB. create two empty files named /output.txt and output.txt
'' fwrite '/output.txt' ; 'output.txt'

require 'general/dirutils'   NB. addon package
NB. create two directories: /docs and docs:
dircreate '/docs' ; 'docs'
