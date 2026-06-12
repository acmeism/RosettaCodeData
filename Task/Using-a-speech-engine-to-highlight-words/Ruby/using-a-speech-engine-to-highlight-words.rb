load 'speechsynthesis.rb'

if ARGV.length == 1
  $text = "This is default text for the highlight and speak program"
else
  $text = ARGV[1..-1].join(" ")
end
$words = $text.split

Shoes.app do
  @idx = 0

  stack do
    @sentence = para(strong($words[0] + " "), $words[1..-1].map {|word| span(word + " ")})
    button "Say word" do
      say_and_highlight
    end
  end

  keypress do |key|
    case key
    when :control_q, "\x11" then exit
    end
  end

  def say_and_highlight
    speak $words[@idx]
    @idx = (@idx + 1) % $words.length
    @sentence.replace($words.each_with_index.map {|word, idx| idx == @idx ? strong(word + " ") : span(word + " ")})
  end
end
