eight_ball <- function()
{
    responses <- c("It is certain", "It is decidedly so", "Without a doubt",
                   "Yes, definitely", "You may rely on it", "As I see it, yes",
                   "Most likely", "Outlook good", "Signs point to yes", "Yes",
                   "Reply hazy, try again", "Ask again later",
                   "Better not tell you now", "Cannot predict now",
                   "Concentrate and ask again", "Don't bet on it",
                   "My reply is no", "My sources say no", "Outlook not so good",
                   "Very doubtful")

    question <- ""

    cat("Welcome to 8 ball!\n\n", "Please ask yes/no questions to get answers.",
        " Type 'quit' to exit the program\n\n")

    while(TRUE)
    {
        question <- readline(prompt="Enter Question: ")
        if(question == 'quit')
        {
            break
        }
        randint <- runif(1, 1, 20)
        cat("Response: ", responses[randint], "\n")
    }
}

if(!interactive())
{
    eight_ball()
}
