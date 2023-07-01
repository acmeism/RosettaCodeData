# syntax: GAWK -f CHINESE_ZODIAC.AWK
BEGIN {
    print("year element animal  aspect")
    split("Rat,Ox,Tiger,Rabbit,Dragon,Snake,Horse,Goat,Monkey,Rooster,Dog,Pig",animal_arr,",")
    split("Wood,Fire,Earth,Metal,Water",element_arr,",")
    n = split("1935,1938,1968,1972,1976,1984,1985,2017",year_arr,",")
    for (i=1; i<=n; i++) {
      year = year_arr[i]
      element = element_arr[int((year-4)%10/2)+1]
      animal = animal_arr[(year-4)%12+1]
      yy = (year%2 == 0) ? "Yang" : "Yin"
      printf("%4d %-7s %-7s %s\n",year,element,animal,yy)
    }
    exit(0)
}
