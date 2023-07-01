define(`striptwo',`substr(`$1',1,eval(len(`$1')-2))')dnl
define(`cmplast',`ifelse(`striptwo(`$1')',,`yes',dnl
substr(`$1',0,1),substr(`$1',eval(len(`$1')-1),1),`yes',`no')')dnl
define(`palindro',`dnl
ifelse(eval(len(`$1')<1),1,`yes',cmplast(`$1'),`yes',`palindro(striptwo(`$1'))',`no')')dnl
palindro(`ingirumimusnocteetconsumimurigni')
palindro(`this is not palindrome')
