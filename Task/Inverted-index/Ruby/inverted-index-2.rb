if File.exist? "index.dat"
  @data = Marshal.load open("index.dat")
else
  raise "The index data file could not be located."
end

class String
  def index_sanitize
    self.split.collect do |token|
      token.downcase.gsub(/\W/, '')
    end
  end
end

# Take anything passed in on the command line in any form and break it
# down the same way we did when making the index.
ARGV.join(' ').index_sanitize.each do |word|
  @result ||= @data[word]
  @result &= @data[word]
end

p @result
