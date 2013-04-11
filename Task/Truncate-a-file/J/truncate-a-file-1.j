require 'files'                         NB. needed for versions prior to J7
ftruncate=: ] fwrite~ ] fread@; 0 , [
