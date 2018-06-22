# Project : Probabilistic choice
# Date    : 2017/10/01
# Author  : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

cnt = list(8)
item = ["aleph","beth","gimel","daleth","he","waw","zayin","heth"]
prob  = [1/5.0, 1/6.0, 1/7.0, 1/8.0, 1/9.0, 1/10.0, 1/11.0, 1759/27720]

for trial = 1 to 1000000
    r = random(10)/10
    p = 0
    for i = 1 to len(prob)
        p = p + prob[i]
        if r < p
           cnt[i] = cnt[i] + 1
           loop
        ok
    next
next

see "item     actual    theoretical" + nl
for i = 1 to len(item)
    see "" + item[i] + "    " + cnt[i]/1000000 + "    " + prob[i] + nl
next
