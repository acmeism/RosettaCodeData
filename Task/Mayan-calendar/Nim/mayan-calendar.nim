import math, strformat, times

const

  Tzolk´in = ["Imix´", "Ik´", "Ak´bal", "K´an", "Chikchan", "Kimi", "Manik´", "Lamat", "Muluk", "Ok",
              "Chuwen", "Eb", "Ben", "Hix", "Men", "K´ib´", "Kaban", "Etz´nab´", "Kawak", "Ajaw"]

  Haab´ = ["Pop", "Wo´", "Sip", "Sotz´", "Sek", "Xul", "Yaxk´in", "Mol", "Ch´en", "Yax",
           "Sak´", "Keh", "Mak", "K´ank´in", "Muwan", "Pax", "K´ayab", "Kumk´u", "Wayeb´"]

let
  creationTzolk´in = initDateTime(21, mDec, 2012, 0, 0, 0, utc())
  zeroHaab´ = initDateTime(2, mApr, 2019, 0, 0, 0, utc())

func daysPerMayanMonth(month: string): int =
  if month == "Wayeb´": 5 else: 20

proc tzolkin(gregorian: DateTime): string =
  let deltaDays = (gregorian - creationTzolk´in).inDays
  let rem = floorMod(deltaDays, 13)
  result = $(if rem <= 9: rem + 4 else: rem - 9) & ' ' & Tzolk´in[floorMod(deltaDays - 1, 20)]

proc haab(gregorian: DateTime): string =
  let rem = floorMod((gregorian - zeroHaab´).inDays, 365)
  let month = Haab´[(rem + 1) div 20]
  let dayOfMonth = rem mod 20 + 1
  result = if dayOfMonth < daysPerMayanMonth(month): &"{dayOfMonth} {month}" else: &"Chum {month}"

proc toLongDate(gregorian: DateTime): string =
  var delta = (gregorian - creationTzolk´in).inDays + 13 * 360 * 400
  var baktun = delta div (360 * 400)
  delta = delta mod (400 * 360)
  let katun = delta div (20 * 360)
  delta = delta mod (20 * 360)
  let tun = delta div 360
  delta = delta mod 360
  let winal = delta div 20
  let kin = delta mod 20
  result = &"{baktun:2} {katun:2} {tun:2} {winal:2} {kin:2}"

proc nightLord(gregorian: DateTime): string =
  var rem = (gregorian - creationTzolk´in).inDays mod 9
  if rem <= 0: rem += 9
  result = 'G' & $rem


when isMainModule:

  let testDates = [initDateTime(21, mNov, 1963, 0, 0, 0, utc()),
                   initDateTime(19, mJun, 2004, 0, 0, 0, utc()),
                   initDateTime(18, mDec, 2012, 0, 0, 0, utc()),
                   initDateTime(21, mDec, 2012, 0, 0, 0, utc()),
                   initDateTime(19, mJan, 2019, 0, 0, 0, utc()),
                   initDateTime(27, mMar, 2019, 0, 0, 0, utc()),
                   initDateTime(29, mFeb, 2020, 0, 0, 0, utc()),
                   initDateTime(01, mMar, 2020, 0, 0, 0, utc()),
                   initDateTime(16, mMay, 2071, 0, 0, 0, utc()),
                   initDateTime(02, mfeb, 2020, 0, 0, 0, utc())]

echo "Gregorian      Long Count       Tzolk´in  Haab´       Nightlord"
echo "———————————————————————————————————————————————————————————————"
for date in testDates:
  let dateStr = date.format("YYYY-MM-dd")
  echo &"{dateStr:14} {date.toLongDate:16} {tzolkin(date):9} {haab(date):14} {nightLord(date)}"
