DigSq ? {
  d ? ×˜ ?10                  # Digit values
  m ? 1+81×2???                # One plus maximum digit sum
  c ? (+´ d ??0?»¨ <)??? m??1  # Count of numbers having each sum
  s ? m ? ? d +??(?10??m) 0   # Sum for each sum
  e ? 1??˜?(?2???)s           # Which sums end at 89
  ¯1 +´ c×e                   # Total up; subtract 1 to exclude 0
}
