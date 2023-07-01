# syntax: GAWK -f MAGIC_8-BALL.AWK
BEGIN {
# Ten answers are affirmative, five are non-committal, and five are negative.
    arr[++i] = "It is certain"
    arr[++i] = "It is decidedly so"
    arr[++i] = "Without a doubt"
    arr[++i] = "Yes, definitely"
    arr[++i] = "You may rely on it"
    arr[++i] = "As I see it, yes"
    arr[++i] = "Most likely"
    arr[++i] = "Outlook good"
    arr[++i] = "Signs point to yes"
    arr[++i] = "Yes"
    arr[++i] = "Reply hazy, try again"
    arr[++i] = "Ask again later"
    arr[++i] = "Better not tell you now"
    arr[++i] = "Cannot predict now"
    arr[++i] = "Concentrate and ask again"
    arr[++i] = "Don't bet on it"
    arr[++i] = "My reply is no"
    arr[++i] = "My sources say no"
    arr[++i] = "Outlook not so good"
    arr[++i] = "Very doubtful"
    srand()
    printf("Please enter your question or a blank line to quit.\n")
    while (1) {
      printf("\n? ")
      getline ans
      if (ans ~ /^ *$/) {
        break
      }
      printf("%s\n",arr[int(rand()*i)+1])
    }
    exit(0)
}
