local months={"JAN","MAR","MAY","JUL","AUG","OCT","DEC"}
local daysPerMonth={31+28,31+30,31+30,31,31+30,31+30,0}

function find5weMonths(year)
  local list={}
  local startday=((year-1)*365+math.floor((year-1)/4)-math.floor((year-1)/100)+math.floor((year-1)/400))%7

  for i,v in ipairs(daysPerMonth) do
    if startday==4 then list[#list+1]=months[i] end
    if i==1 and year%4==0 and year%100~=0 or year%400==0 then
      startday=startday+1
    end
    startday=(startday+v)%7
  end
  return list
end

local cnt_months=0
local cnt_no5we=0

for y=1900,2100 do
  local list=find5weMonths(y)
  cnt_months=cnt_months+#list
  if #list==0 then
    cnt_no5we=cnt_no5we+1
  end
  print(y.." "..#list..": "..table.concat(list,", "))
end
print("Months with 5 weekends: ",cnt_months)
print("Years without 5 weekends in the same month:",cnt_no5we)
