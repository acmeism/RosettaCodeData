# Project : Evolutionary algorithm
# Date    : 2018/03/28
# Author : Gal Zsolt [~ CalmoSoft ~]
# Email   : <calmosoft@gmail.com>

target = "METHINKS IT IS LIKE A WEASEL"
parent = "IU RFSGJABGOLYWF XSMFXNIABKT"
num = 0
mutationrate = 0.5
children = len(target)
child = list(children)
while parent != target
        bestfitness = 0
        bestindex = 0
        for index = 1 to children
             child[index] = mutate(parent, mutationrate)
             fitness = fitness(target, child[index])
             if fitness > bestfitness
                bestfitness = fitness
                bestindex = index
             ok
        next
        if bestindex > 0
           parent = child[bestindex]
           num = num + 1
           see "" + num + ": " + parent + nl
        ok
end

func fitness(text, ref)
       f = 0
       for i = 1 to len(text)
            if substr(text, i, 1) = substr(ref, i, 1)
               f = f + 1
            ok
       next
       return (f / len(text))

func mutate(text, rate)
        rnd = randomf()
        if rate > rnd
           c = 63+random(27)
           if c = 64
              c = 32
           ok
           rnd2 = random(len(text))
           if rnd2 > 0
              text[rnd2] = char(c)
           ok
        ok
        return text

func randomf()
       decimals(10)
       str = "0."
       for i = 1 to 10
            nr = random(9)
            str = str + string(nr)
       next
       return number(str)
