module EBNF
  class Syntax
    getter prods, start
    getter title, comment
    def initialize (@prods : Hash(String, Prod), @start : Prod, title, comment)
      @comment = comment || ""
      @title = title || ""
    end

    def matches (s)
      sc = Scanner.new s
      start.expr.matches sc
      sc.eof?
    end

    def dump (io)
      io.puts "title:   #{title}"
      io.puts "comment: #{comment}"
      io.puts "productions:"
      prods.keys.sort.each do |prod|
        head = "  #{prod} = "
        io << head
        prods[prod].expr.dump io, head.size
        io.puts
      end
      io.puts "start: #{start.name}"
    end

    def self.parse (source)
      syntax = Parser.new(source).parse_syntax
      syntax.prods.each_value do |prod|
        prod.fix_refs syntax.prods
      end
      syntax
    end
  end

  class Scanner
    getter ch : Char?, io

    def initialize (@io : IO)
      get
    end

    def initialize (s : String)
      @io = IO::Memory.new(s.to_slice, false)
      get
    end

    def get
      @ch = io.read_char
    end

    def save
      { @ch, io.pos }
    end

    def restore (tuple)
      @ch, @io.pos = tuple
    end

    def skip_spaces
      while (c = ch) && c.whitespace?; get; end
    end

    def over (s : String)
      s.each_char do |char|
        raise "<#{s}> expected at #{io.pos}" unless ch == char
        get
      end
    end

    def over (char : Char)
      over char.to_s
    end

    def over_one_of (s, msg = nil)
      msg ||= "one of <#{s}> expected"
      raise "#{msg} at #{io.pos}" unless (c = ch) && c.in_set? s
      get
    end

    def string
      quote = ch.not_nil!
      over quote
      result = String.build do |s|
        while (c = ch) && c != quote
          s << c; get
        end
      end
      over quote
      result
    end

    def ident
      raise "letter expected at #{io.pos}" unless (c = ch) && c.letter?
      String.build do |s|
        s << c; get
        while (c = ch) && c.alphanumeric?
          s << c; get
        end
      end
    end

    def eof?; ch == nil; end
  end

  class Parser
    getter sc
    def initialize (io)
      @sc = Scanner.new io
    end

    def skip; sc.skip_spaces; end

    def parse_syntax
      skip; title = if (c = sc.ch) && c.in_set? "'\""
                      sc.string
                    end
      prods = Hash(String, Prod).new
      first_prod = nil
      skip; sc.over '{'; skip
      while (c = sc.ch) && c.letter?
        prod = parse_prod
        first_prod ||= prod.name
        prods[prod.name] = prod
        skip
      end
      raise "production expected at #{sc.io.pos}" unless first_prod
      sc.over '}'
      skip; comment = if (c = sc.ch) && c.in_set? "\"'"
                        sc.string
                      end
      EBNF::Syntax.new prods, prods[first_prod], title, comment
    end

    def parse_prod
      skip; name = sc.ident
      skip; sc.over '='
      expr = parse_or
      skip; sc.over_one_of ".;", "terminator expected"
      EBNF::Prod.new name, expr
    end

    def parse_or
      exprs = [] of Expr
      loop do
        exprs << parse_seq
        skip; break unless sc.ch == '|'
        sc.over '|'
      end
      return exprs[0] if exprs.size == 1
      OrExpr.new exprs
    end

    def parse_seq
      exprs = [] of Expr
      loop do
        skip; break unless (c = sc.ch)
        case c
        when .letter?       then exprs << RefExpr.new sc.ident
        when .in_set? "\"'" then exprs << LitExpr.new sc.string
        when '[' then sc.over '['; exprs << OptExpr.new parse_or; sc.over ']'
        when '{' then sc.over '{'; exprs << RepExpr.new parse_or; sc.over '}'
        when '(' then sc.over '('; exprs << parse_or;             sc.over ')'
        else
          break
        end
      end
      raise "this parser doesn't support empty productions, at #{sc.io.pos}" unless exprs.size > 0
      return exprs[0] if exprs.size == 1
      SeqExpr.new exprs
    end
  end

  class Prod
    getter name, expr
    def initialize (@name : String, @expr : Expr)
    end

    def fix_refs (prods)
      @expr.fix_refs prods
    end
  end

  abstract class Expr
    getter subexprs = [] of Expr
    getter op = ""

    def dump (io, indent)
      io << "(" << op << " "
      newindent = indent + op.size + 2
      first = true
      subexprs.each do |expr|
        unless first
          io << "\n" << " " * newindent
        end
        first = false
        expr.dump io, newindent
      end
      io << ")"
    end

    def fix_refs (prods)
      subexprs.each &.fix_refs(prods)
    end
  end

  class OrExpr < Expr
    def initialize (@subexprs)
      @op = "or"
    end

    def matches (sc)
      pos = sc.save
      subexprs.each do |alt|
        return true if alt.matches sc
        sc.restore pos
      end
      false
    end
  end

  class SeqExpr < Expr
    def initialize (@subexprs)
      @op = "and"
    end

    def matches (sc)
      subexprs.each do |expr|
        return false unless expr.matches sc
      end
      true
    end
  end

  class RefExpr < Expr
    getter name, ref : Expr?
    def initialize (@name : String)
      @op = "ref"
    end

    def fix_refs (prods)
      @ref = prods[name]?.try &.expr
      raise "undefined production <#{name}>" unless @ref
    end

    def dump (io, indent=0)
      io << "<" << name << ">"
    end

    def matches (sc)
      raise "undefined production <#{name}>" unless ref
      ref.not_nil!.matches sc
    end
  end

  class LitExpr < Expr
    getter string

    def initialize (@string : String)
    end

    def dump (io, indent=0)
      string.inspect io
    end

    def matches (sc)
      sc.skip_spaces # necessary to pass tests (!?)
      begin
        sc.over string
      rescue
        return false
      end
      true
    end
  end

  class OptExpr < Expr
    def initialize (expr)
      @op = "opt"
      @subexprs = [expr]
    end

    def matches (sc)
      pos = sc.save
      unless subexprs.first.matches sc
        sc.restore pos
      end
      true
    end
  end

  class RepExpr < Expr
    def initialize (expr)
      @op = "rep"
      @subexprs = [expr]
    end

    def matches (sc)
      pos = sc.save
      while subexprs.first.matches sc
        pos = sc.save
      end
      sc.restore pos
      true
    end
  end
end

def test (syntax, tests)
  puts "SOURCE:"
  puts syntax
  syn = EBNF::Syntax.parse syntax
  puts "PARSED:"
  syn.dump STDOUT
  puts "TESTS:"
  tests.each do |test|
    result = syn.matches(test) ? "PASS" : "fail"
    puts "  #{result}  #{test}"
  end
end

syntax = <<-EOT
"a" {
    a = "a1" ( "a2" | "a3" ) { "a4" } [ "a5" ] "a6" ;
} "z"
EOT

test syntax, ["a1a3a4a4a5a6", "a1 a2a6", "a1 a3 a4 a6", "a1 a4 a5 a6",
              "a1 a2 a4 a5 a5 a6", "a1 a2 a4 a5 a6 a7", "your ad here"]

puts
syntax = <<-EOT
{
    expr = term { plus term } .
    term = factor { times factor } .
    factor = number | '(' expr ')' .

    plus = "+" | "-" .
    times = "*" | "/" .

    number = digit { digit } .
    digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" .
}
EOT

test syntax, ["2", "2*3 + 4/23 - 7", "(3 + 4) * 6-2+(4*(4))", "-2", "3 +", "(4 + 3"]

puts
puts "INVALID SYNTAXES:"
[%<a = "1";>, %<{ a = "1" ;>, %<{ hello world = "1"; }>, %<{ foo = bar . }>].each do |syn|
  puts "Parsing syntax: #{syn}"
  print "  -> "
  begin
    EBNF::Syntax.parse syn
    puts "parsed OK (!!)"
  rescue e
    puts "Error: #{e.message}"
  end
end
