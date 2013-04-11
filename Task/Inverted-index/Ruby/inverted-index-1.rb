if File.exist? "index.dat"
  @data = Marshal.load open("index.dat")
else
  @data = {}
end

# Let's give the string class the ability to tokenize itsself into lowercase
# words with no punctuation.
class String
  def index_sanitize
    self.split.collect do |token|
      token.downcase.gsub(/\W/, '')
    end
  end
end

# Just implementing a simple inverted index here.
ARGV.each do |filename|
  open filename do |file|
    file.read.index_sanitize.each do |word|
      @data[word] ||= []
      @data[word] << filename unless @data[word].include? filename
    end
  end
end

open("index.dat", "w") do |index|
  index.write Marshal.dump(@data)
end
