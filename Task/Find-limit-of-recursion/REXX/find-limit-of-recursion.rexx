-- 7 Aug 2025
parse version version
say 'FIND LIMIT OF RECURSION'
say version
say
n=1
call Task
exit

Task:
say n; n=n+1
call Task
return
