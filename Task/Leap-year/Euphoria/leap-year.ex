function isLeapYear(integer year)
    return remainder(year,4)=0 and remainder(year,100)!=0 or remainder(year,400)=0
end function
