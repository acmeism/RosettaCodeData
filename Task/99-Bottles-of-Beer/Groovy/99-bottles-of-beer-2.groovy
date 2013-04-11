298.downto(2) {
    def (m,d) = [it%3,(int)it/3]
    print "${m==1?'\n':''}${d?:'No more'} bottle${d!=1?'s':''} of beer" +
          "${m?' on the wall':'\nTake one down, pass it around'}\n"
}
