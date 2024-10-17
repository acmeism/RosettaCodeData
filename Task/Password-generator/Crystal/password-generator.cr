require "random/secure"

special_chars = true
similar = 0
require_groups = true
length = 20
count = 1

def show_usage
  puts <<-USAGE

       Passwords generator
       Usage: pass2 [count] [-l<length>] [-s{0|1|2}] [-ng] [-ns]

         count: number of passwords to be generated (default: 1)
         -l<length>: length of passwords (default: 20)
         -s{0|1|2}: exclude visually similar characters.
                      0 - don't exclude (default)
                      1 - exclude 0, O, 1, I, l, |
                      2 - also exclude 2, Z, 5, S
        -ng: don''t require password to include character from every group
        -ns: don''t include special chars in password

        Default value of switches is choosen to match the task in page header, but I suggest to use the "-s1 -ng -ns".
       USAGE
end

count_set = false
begin
  ARGV.each do |arg|
    case arg
    when /-l(\d+)/
      length = $1.to_i
      raise "Error: minimal length is 4" if length < 4
    when /-s(\d)/
      similar = $1.to_i
      raise "Error: minimal length is 4" unless {0, 1, 2}.includes? similar
    when /-ng/
      require_groups = false
    when /-ns/
      special_chars = false
    when /(\d+)/
      raise "incorrect arguments" if count_set
      count_set = true
      count = $1.to_i
    else
      raise "incorrect argument"
    end
  end
rescue ex
  puts ex.message
  show_usage
  exit
end

# actual program
GROUPS = [('a'..'z').to_a, ('A'..'Z').to_a, ('0'..'9').to_a]
GROUPS << "!\"#$%&'()*+,-./:;<=>?@[]^_{|}~".chars if special_chars

letters = GROUPS.flatten
letters -= "1l|I0O".chars if similar > 0
letters -= "5S2Z".chars if similar > 1

loop do
  s = Array(Char).new(length) { letters.sample(Random::Secure) }
  # it's better to just discard in order to don't lose enthropy
  next if require_groups && GROUPS.any? { |x| (s & x).size == 0 }
  puts s.join
  count -= 1
  break if count <= 0
end
