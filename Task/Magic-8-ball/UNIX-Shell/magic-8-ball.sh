#!/bin/bash

RESPONSES=("It is certain" "It is decidedly so" "Without a doubt"
           "Yes definitely" "You may rely on it" "As I see it yes"
           "Most likely" "Outlook good" "Signs point to yes" "Yes"
           "Reply hazy try again" "Ask again later"
           "Better not tell you now" "Cannot predict now"
           "Concentrate and ask again" "Don't bet on it"
           "My reply is no" "My sources say no" "Outlook not so good"
           "Very doubtful")

printf "Welcome to 8 ball! Enter your questions using the prompt below to
find the answers you seek. Type 'quit' to exit.\n\n"

while true; do
    read -p 'Enter Question: ' question
    if [ "$question" == "quit" ]; then
        exit 0
    fi

    response_index=$(($RANDOM % 20))

    printf "Response: ${RESPONSES[response_index]}\n\n"
done
