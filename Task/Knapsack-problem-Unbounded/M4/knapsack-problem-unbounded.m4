divert(-1)
define(`set2d',`define(`$1[$2][$3]',`$4')')
define(`get2d',`defn(`$1[$2][$3]')')
define(`for',
   `ifelse($#,0,``$0'',
   `ifelse(eval($2<=$3),1,
   `pushdef(`$1',$2)$4`'popdef(`$1')$0(`$1',incr($2),$3,`$4')')')')

define(`min',
   `define(`ma',eval($1))`'define(`mb',eval($2))`'ifelse(eval(ma<mb),1,ma,mb)')

define(`setv',
   `set2d($1,$2,1,$3)`'set2d($1,$2,2,$4)`'set2d($1,$2,3,$5)`'set2d($1,$2,4,$6)')

dnl  name,value (each),weight,volume
setv(a,0,`knapsack',0,250,250)
setv(a,1,`panacea',3000,3,25)
setv(a,2,`ichor',1800,2,15)
setv(a,3,`gold',2500,20,2)

define(`mv',0)
for(`x',0,min(get2d(a,0,3)/get2d(a,1,3),get2d(a,0,4)/get2d(a,1,4)),
   `for(`y',0,min((get2d(a,0,3)-x*get2d(a,1,3))/get2d(a,2,3),
         (get2d(a,0,4)-x*get2d(a,1,4))/get2d(a,2,4)),
      `
define(`z',min((get2d(a,0,3)-x*get2d(a,1,3)-y*get2d(a,2,3))/get2d(a,3,3),
   (get2d(a,0,4)-x*get2d(a,1,4)-y*get2d(a,2,4))/get2d(a,3,4)))
define(`cv',eval(x*get2d(a,1,2)+y*get2d(a,2,2)+z*get2d(a,3,2)))
ifelse(eval(cv>mv),1,
   `define(`mv',cv)`'define(`best',(x,y,z))',
   `ifelse(cv,mv,`define(`best',best (x,y,z))')')
      ')')
divert
mv best
