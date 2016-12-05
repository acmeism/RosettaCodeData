function print_cal(year)
  local months={"JANUARY","FEBRUARY","MARCH","APRIL","MAY","JUNE",
                "JULY","AUGUST","SEPTEMBER","OCTOBER","NOVEMBER","DECEMBER"}
  local daysTitle="MO TU WE TH FR SA SU"
  local daysPerMonth={31,28,31,30,31,30,31,31,30,31,30,31}
  local startday=((year-1)*365+math.floor((year-1)/4)-math.floor((year-1)/100)+math.floor((year-1)/400))%7
  if year%4==0 and year%100~=0 or year%400==0 then
    daysPerMonth[2]=29
  end
  local sep=5
  local monthwidth=daysTitle:len()
  local calwidth=3*monthwidth+2*sep

  function center(str, width)
    local fill1=math.floor((width-str:len())/2)
    local fill2=width-str:len()-fill1
    return string.rep(" ",fill1)..str..string.rep(" ",fill2)
  end

  function makeMonth(name, skip,days)
    local cal={
      center(name,monthwidth),
      daysTitle
    }
    local curday=1-skip
    while #cal<9 do
      line={}
      for i=1,7 do
        if curday<1 or curday>days then
          line[i]="  "
        else
          line[i]=string.format("%2d",curday)
        end
        curday=curday+1
      end
      cal[#cal+1]=table.concat(line," ")
    end
    return cal
  end

  local calendar={}
  for i,month in ipairs(months) do
    local dpm=daysPerMonth[i]
    calendar[i]=makeMonth(month, startday, dpm)
    startday=(startday+dpm)%7
  end


  print(center("[SNOOPY]",calwidth),"\n")
  print(center("--- "..year.." ---",calwidth),"\n")

  for q=0,3 do
    for l=1,9 do
      line={}
      for m=1,3 do
        line[m]=calendar[q*3+m][l]
      end
      print(table.concat(line,string.rep(" ",sep)))
    end
  end
end

print_cal(1969)
