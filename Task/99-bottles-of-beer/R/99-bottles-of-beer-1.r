#a naive function to sing for N bottles of beer...

song = function(bottles){

  for(i in bottles:1){ #for every integer bottles, bottles-1 ... 1

    cat(bottles," bottles of beer on the wall \n",bottles," bottles of beer \nTake one down, pass it around \n",
        bottles-1, " bottles of beer on the wall \n"," \n" ,sep="")       #join and print the text (\n means new line)

        bottles = bottles - 1 #take one down...

  }

}

song(99)#play the song by calling the function
