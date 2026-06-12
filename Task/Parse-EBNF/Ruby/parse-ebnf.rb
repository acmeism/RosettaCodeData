#--
# The tokenizer splits the input into Tokens like "identifier",
# ":", ")*" and so on. This design uses a StringScanner on each line of
# input, therefore a Token can never span more than one line.
#
# Each Token knows its original line and position, so an error message
# can locate a bad token.
#++

require 'strscan'

# A line of input.
# where::  A location like "file.txt:3"
# str::    String of this line
Line = Struct.new :where, :str

# A token.
# cat::   A category like :colon, :ident or so on
# str::   String of this token
# line::  Line containing this token
# pos::   Position of this token within this line
Token = Struct.new :cat, :str, :line, :pos

# Reads and returns the next Token. At end of file, returns nil.
#--
# Needs @filename and @in.
#++
def next_token
  # Loop until we reach a Token.
  loop do
    # If at end of line, then get next line, or else declare end of
    # file.
    if @scanner.eos?
      if s = @in.gets
        # Each line needs a new Line object. Tokens can hold references
        # to old Line objects.
        @line = Line.new("#{@filename}:#{@in.lineno}", s)
        @scanner.string = s
      else
        return nil  # End of file
      end
    end

    # Skip whitespace.
    break unless @scanner.skip(/[[:space:]]+/)
  end

  # Read token by regular expression.
  if s = @scanner.scan(/:/)
    c = :colon
  elsif s = @scanner.scan(/;/)
    c = :semicolon
  elsif s = @scanner.scan(/\(/)
    c = :paren
  elsif s = @scanner.scan(/\)\?/)
    c = :option
  elsif s = @scanner.scan(/\)\*/)
    c = :repeat
  elsif s = @scanner.scan(/\)/)
    c = :group
  elsif s = @scanner.scan(/\|/)
    c = :bar
  elsif s = @scanner.scan(/[[:alpha:]][[:alnum:]]*/)
    c = :ident
  elsif s = @scanner.scan(/'[^']*'|"[^"]*"/)
    # Fix syntax highlighting for Rosetta Code. => '
    c = :string
  elsif s = @scanner.scan(/'[^']*|"[^"]*/)
    c = :bad_string
  elsif s = @scanner.scan(/.*/)
    c = :unknown
  end

  Token.new(c, s, @line, (@scanner.pos - s.length))
end

# Prints a _message_ to standard error, along with location of _token_.
def error(token, message)
  line = token.line

  # We print a caret ^ pointing at the bad token. We make a very crude
  # attempt to align the caret ^ in the correct column. If the input
  # line has a non-[:print:] character, like a tab, then we print it as
  # a space.
  STDERR.puts <<EOF
#{line.where}: #{message}
#{line.str.gsub(/[^[:print:]]/, " ")}
#{" " * token.pos}^
EOF
end


#--
# The parser converts Tokens to a Grammar object. The parser also
# detects syntax errors.
#++

# A parsed EBNF grammar. It is an Array of Productions.
class Grammar < Array; end

# A production.
# ident::  The identifier
# alts::   An Array of Alternatives
Production = Struct.new :ident, :alts

# An array of Alternatives, as from "(a | b)".
class Group < Array; end

# An optional group, as from "(a | b)?".
class OptionalGroup < Group; end

# A repeated group, as from "(a | b)*".
class RepeatedGroup < Group; end

# An array of identifiers and string literals.
class Alternative < Array; end

#--
# Needs @filename and @in.
#++
def parse
  # TODO: this only dumps the tokens.
  while t = next_token
    error(t, "#{t.cat}")
  end
end

# Set @filename and @in. Parse input.
case ARGV.length
when 0 then @filename = "-"
when 1 then @filename = ARGV[0]
else fail "Too many arguments"
end
open(@filename) do |f|
  @in = f
  @scanner = StringScanner.new("")
  parse
end
