import std/[algorithm, sugar]
import integers

let k = newInteger("960939379918958884971672962127852754715004339660129306651505519" &
                   "271702802395266424689642842174350718121267153782770623355993237" &
                   "280874144307891325963941337723487857735749823926629715517173716" &
                   "995165232890538221612403238855866184013235585136048828693337902" &
                   "491454229288667081096184496091705183454067827731551705405381627" &
                   "380967602565625016981482083418783163849115590225610003652351370" &
                   "343874461848378737238198224849863465033159410054974700593138339" &
                   "226497249461751545728366702369745461014655997933798537483143786" &
                   "841806593422227898388722980000748404719")

proc tuppersFormula(x, y: Integer): bool =
  ## Return true if point at (x, y) (x and y both start at 0)
  ## is to be drawn black, False otherwise
  result = (k + y) div 17 div 2^(17 * x + y mod 17) mod 2 != 0

let values = collect:
               for y in 0..16:
                 collect:
                   for x in 0..105:
                     tuppersFormula(x, y)

let f = open("tupper.txt", fmWrite)
for row in values:
  for value in reversed(row):   # x = 0 starts at the left so reverse the whole row.
    f.write if value: "\u2588" else: " "
  f.write '\n'
f.close()
