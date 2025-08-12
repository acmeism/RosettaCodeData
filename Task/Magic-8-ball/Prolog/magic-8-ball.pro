magic_8_ball :-
    Responses = ["It is certain", "It is decidedly so", "Without a doubt",
        "Yes, definitely", "You may rely on it", "As I see it, yes", "Most likely",
        "Outlook good", "Signs point to yes", "Yes", "Reply hazy, try again",
        "Ask again later", "Better not tell you now", "Cannot predict now",
        "Concentrate and ask again", "Don't bet on it", "My reply is no",
        "My sources say no", "Outlook not so good", "Very doubtful"],
    repeat,
    format("Q:   "),
    read_line_to_codes(user_input, _),
    random_member(Response, Responses),
    format("A:   ~s~n", [Response]),
    fail.
