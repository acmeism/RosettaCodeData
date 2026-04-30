# syntax: GAWK -f SEARCH_A_LIST_OF_RECORDS.AWK
BEGIN {
    cities_arr[0] = "Lagos"                ; population_arr[0] = 21.0
    cities_arr[1] = "Cairo"                ; population_arr[1] = 15.2
    cities_arr[2] = "Kinshasa-Brazzaville" ; population_arr[2] = 11.3
    cities_arr[3] = "Greater Johannesburg" ; population_arr[3] = 7.55
    cities_arr[4] = "Mogadishu"            ; population_arr[4] = 5.85
    cities_arr[5] = "Khartoum-Omdurman"    ; population_arr[5] = 4.98
    cities_arr[6] = "Dar Es Salaam"        ; population_arr[6] = 4.7
    cities_arr[7] = "Alexandria"           ; population_arr[7] = 4.58
    cities_arr[8] = "Abidjan"              ; population_arr[8] = 4.4
    cities_arr[9] = "Casablanca"           ; population_arr[9] = 3.98
    limit = 9
# Find the (zero-based) index of the first city whose name is "Dar Es Salaam"
    for (i=0; i<=limit; i++) {
      if (cities_arr[i] == "Dar Es Salaam") {
        print(i)
        break
      }
    }
# Find the name of the first city whose population is less than 5 million
    for (i=0; i<=limit; i++) {
      if (population_arr[i] < 5) {
        print(cities_arr[i])
        break
      }
    }
# Find the population of the first city whose name starts with the letter "A"
    for (i=0; i<=limit; i++) {
      if (cities_arr[i] ~ /^A/) {
        print(population_arr[i])
        break
      }
    }
    exit(0)
}
