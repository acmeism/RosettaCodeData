import strutils except align
from unicode import align

func separateHouseNumber(address: string): tuple[street, house: string] =
  let fields = address.splitWhitespace()
  let last = fields[^1]
  let penult = fields[^2]
  if last[0].isDigit():
    let isdig = penult[0].isDigit()
    if fields.len > 2 and isdig and not penult.startsWith("194"):
      result.house = penult & ' ' & last
    else:
      result.house = last
  elif fields.len > 2:
    result.house = penult & ' ' & last
  result.street = address[0..address.high-result.house.len].strip(leading = false, trailing = true)

const Addresses = ["Plataanstraat 5",
                   "Straat 12",
                   "Straat 12 II",
                   "Dr. J. Straat   12",
                   "Dr. J. Straat 12 a",
                   "Dr. J. Straat 12-14",
                   "Laan 1940 - 1945 37",
                   "Plein 1940 2",
                   "1213-laan 11",
                   "16 april 1944 Pad 1",
                   "1e Kruisweg 36",
                   "Laan 1940-'45 66",
                   "Laan '40-'45",
                   "Langeloërduinen 3 46",
                   "Marienwaerdt 2e Dreef 2",
                   "Provincialeweg N205 1",
                   "Rivium 2e Straat 59.",
                   "Nieuwe gracht 20rd",
                   "Nieuwe gracht 20rd 2",
                   "Nieuwe gracht 20zw /2",
                   "Nieuwe gracht 20zw/3",
                   "Nieuwe gracht 20 zw/4",
                   "Bahnhofstr. 4",
                   "Wertstr. 10",
                   "Lindenhof 1",
                   "Nordesch 20",
                   "Weilstr. 6",
                   "Harthauer Weg 2",
                   "Mainaustr. 49",
                   "August-Horch-Str. 3",
                   "Marktplatz 31",
                   "Schmidener Weg 3",
                   "Karl-Weysser-Str. 6"]

echo "       Street            House Number"
echo "—————————————————————    ————————————"
for address in Addresses:
  let (street, house) = address.separateHouseNumber()
  echo street.align(22), "   ", if house.len != 0: house else: "(none)"
