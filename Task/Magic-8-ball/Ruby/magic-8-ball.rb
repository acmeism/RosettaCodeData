#!/usr/bin/ruby

class EightBall
  def initialize
    print "Welcome to 8 ball! Ask your question below. "
    puts "Type 'quit' to exit the program.\n\n"
    @responses = ["It is certain", "It is decidedly so",
                          "Without a doubt", "Yes, definitely",
                          "You may rely on it", "As I see it, yes",
                          "Most likely", "Outlook good",
                          "Signs point to yes", "Yes",
                          "Reply hazy, try again", "Ask again later",
                          "Better not tell you now",
                          "Cannot predict now",
                          "Concentrate and ask again", "Don't bet on it",
                          "My reply is no", "My sources say no",
                          "Outlook not so good", "Very doubtful"]
  end

  def ask_question
    print "Question: "
    question = gets

    if question.chomp.eql? "quit"
      exit(0)
    end

    puts "Response: #{@responses.sample} \n\n"
  end

  def run
    loop do
      ask_question
    end
  end
end

eight_ball = EightBall.new
eight_ball.run
