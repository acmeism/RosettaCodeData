//console
var answers = [ "It is certain", "It is decidedly so", "Without a doubt",
        "Yes, definitely", "You may rely on it", "As I see it, yes",
        "Most likely", "Outlook good", "Signs point to yes", "Yes",
        "Reply hazy, try again", "Ask again later",
        "Better not tell you now", "Cannot predict now",
        "Concentrate and ask again", "Don't bet on it",
        "My reply is no", "My sources say no", "Outlook not so good",
        "Very doubtful"])

console.log("ASK ANY QUESTION TO THE MAGIC 8-BALL AND YOU SHALL RECEIVE AN ANSWER!")

for(;;){
  var answer = prompt("question:")
  console.log(answer)
console.log(answers[Math.floor(Math.random()*answers.length)]);
}
