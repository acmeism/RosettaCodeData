import times

const LongMonths = {mJan, mMar, mMay, mJul, mAug, mOct, mDec}

var sumNone = 0
for year in 1900..2100:
  var none = true
  for month in LongMonths:
    if initDateTime(1, month, year, 0, 0, 0).weekday == dFri:
      echo month, " ", year
      none = false
  if none: inc sumNone

echo "\nYears without a 5 weekend month: ", sumNone
