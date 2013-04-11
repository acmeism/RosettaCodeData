define(`upcase', `translit(`$*', `a-z', `A-Z')')
define(`downcase', `translit(`$*', `A-Z', `a-z')')

define(`x',`alphaBETA')
upcase(x)
downcase(x)
