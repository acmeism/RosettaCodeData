/* Rexx */
Do
  cities = .array~of('UK  London', 'US  New York', 'US  Birmingham', 'UK  Birmingham',)

  Say; Say 'Original table'
  Call display cities

  Say; Say 'Unstable sort on city'
  sorted = cities~copy
  sorted~sortWith(.ColumnComparator~new(4, 20))
  Call display sorted

  Say; Say 'Stable sort on city'
  sorted = cities~copy
  sorted~stableSortWith(.ColumnComparator~new(4, 20))
  Call display sorted

  Say; Say 'Unstable sort on country'
  sorted = cities~copy
  sorted~sortWith(.ColumnComparator~new(1, 2))
  Call display sorted

  Say; Say 'Stable sort on country'
  sorted = cities~copy
  sorted~stableSortWith(.ColumnComparator~new(1, 2))
  Call display sorted

  Return
End
Exit

display: Procedure
Do
  Use arg CT

  Say '-'~copies(80)
  Loop c_ over CT
    Say c_
    End c_

  Return
End
Exit
