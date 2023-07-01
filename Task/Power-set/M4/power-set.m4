define(`for',
  `ifelse($#, 0, ``$0'',
          eval($2 <= $3), 1,
          `pushdef(`$1', `$2')$4`'popdef(
             `$1')$0(`$1', incr($2), $3, `$4')')')dnl
define(`nth',
  `ifelse($1, 1, $2,
          `nth(decr($1), shift(shift($@)))')')dnl
define(`range',
  `for(`x', eval($1 + 2), eval($2 + 2),
       `nth(x, $@)`'ifelse(x, eval($2+2), `', `,')')')dnl
define(`powerpart',
  `{range(2, incr($1), $@)}`'ifelse(incr($1), $#, `',
     `for(`x', eval($1+2), $#,
        `,powerpart(incr($1), ifelse(
           eval(2 <= ($1 + 1)), 1,
           `range(2,incr($1), $@), ')`'nth(x, $@)`'ifelse(
              eval((x + 1) <= $#),1,`,range(incr(x), $#, $@)'))')')')dnl
define(`powerset',
  `{powerpart(0, substr(`$1', 1, eval(len(`$1') - 2)))}')dnl
dnl
powerset(`{a,b,c}')
