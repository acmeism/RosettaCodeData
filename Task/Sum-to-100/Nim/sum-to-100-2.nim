import strutils

var
  ligne: string = ""
  sum: int
  opera: array[0..9, int] = [0,0,1,1,1,1,1,1,1,1]
  curseur: int = 9
  boucle: bool
  tot: array[1..123456789, int]
  pG: int
  plusGrandes: array[1..10, string]

let
  ope: array[0..3, string] = ["-",""," +"," -"]
  aAtteindre = 100

proc calcul(li: string): int =
  var liS: seq[string]
  liS = split(li," ")
  for i in liS:
    if i.len > 0: result += parseInt(i)

echo "Valeur à atteindre : ",aAtteindre

while opera[1]<2:
  ligne.add(ope[opera[1]])
  ligne.add("1")
  for i in 2..9:
    ligne.add(ope[opera[i]])
    ligne.add($i)
  sum = calcul(ligne)
  if sum == aAtteindre:
    stdout.write(ligne)
    echo " = ",sum
  if sum>0:
    tot[sum] += 1
    pG = 1
    while pG<10:
      if sum>calcul(plusGrandes[pG]):
        for k in countdown(10,pG+1):
          plusGrandes[k]=plusGrandes[k-1]
        plusGrandes[pG]=ligne
        pG = 11
      pG += 1
  ligne = ""
  boucle = true
  while boucle:
    opera[curseur] += 1
    if opera[curseur] == 4:
      opera[curseur]=1
      curseur -= 1
    else:
      curseur = 9
      boucle = false

echo "Valeur atteinte ",tot[aAtteindre]," fois."
echo ""

var
  min0: int = 0
  max: int = 0
  valmax: int = 0

for i in 1..123456789:
  if tot[i]==0 and min0 == 0:
    min0 = i
  if tot[i]>max:
    max = tot[i]
    valmax = i

echo "Plus petite valeur ne pouvant pas être atteinte : ",min0
echo "Valeur atteinte le plus souvent : ",valmax,", atteinte ",max," fois."
echo ""
echo "Plus grandes valeurs pouvant être atteintes :"
for i in 1..10:
  echo calcul(plusGrandes[i])," = ",plusGrandes[i]
