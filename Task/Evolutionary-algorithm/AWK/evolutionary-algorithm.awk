#!/bin/awk -f
function randchar(){
return substr(charset,randint(length(charset)+1),1)
}
function mutate(gene,rate    ,l,newgene){
newgene = ""
for (l=1; l < 1+length(gene); l++){
if (rand() < rate)
   newgene = newgene randchar()
else
   newgene = newgene substr(gene,l,1)
}
return newgene
}
function fitness(gene,target  ,k,fit){
fit = 0
for (k=1;k<1+length(gene);k++){
if (substr(gene,k,1) == substr(target,k,1)) fit = fit + 1
}
return fit
}
function randint(n){
return int(n * rand())
}
function evolve(){
     maxfit = fitness(parent,target)
     oldfit = maxfit
     maxj = 0
     for (j=1; j < D; j++){
         child[j] = mutate(parent,mutrate)
         fit[j] = fitness(child[j],target)
         if (fit[j] > maxfit) {
            maxfit = fit[j]
            maxj = j
            }
          }
     if (maxfit > oldfit) parent = child[maxj]
     }

BEGIN{
target = "METHINKS IT IS LIKE A WEASEL"
charset = " ABCDEFGHIJKLMNOPQRSTUVWXYZ"
mutrate = 0.10
if (ARGC > 1) mutrate = ARGV[1]
lenset = length(charset)
C = 100
D = C + 1
parent = ""
for (j=1; j < length(target)+1; j++) {
     parent = parent randchar()
     }
print "target: " target
print "fitness of target: " fitness(target,target)
print "initial parent: " parent
gens = 0
while (parent != target){
      evolve()
      gens = gens + 1
      if (gens % 10 == 0) print "after " gens " generations,","new parent: " parent," with fitness: " fitness(parent,target)
      }
print "after " gens " generations,"," evolved parent: " parent
}
