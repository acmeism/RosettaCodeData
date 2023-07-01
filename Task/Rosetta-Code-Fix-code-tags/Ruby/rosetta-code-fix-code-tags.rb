# get all stdin in one string
#text = $stdin.read
# for testing, use
text = DATA.read
slash_lang = '/lang'
langs = %w(foo bar baz) # actual list of languages declared here
for lang in langs
  text.gsub!(Regexp.new("<(#{lang})>")) {"<lang #$1>"}
  text.gsub!(Regexp.new("</#{lang}>"), "<#{slash_lang}>")
end
text.gsub!(/<code (.*?)>/, '<lang \1>')
text.gsub!(/<\/code>/, "<#{slash_lang}>")
print text

__END__
Lorem ipsum <code foo>saepe audire</code> elaboraret ne quo, id equidem
atomorum inciderint usu. <foo>In sit inermis deleniti percipit</foo>,
ius ex tale civibus omittam. <barf>Vix ut doctus cetero invenire</barf>, his eu
altera electram. Tota adhuc altera te sea, <code bar>soluta appetere ut mel</bar>.
Quo quis graecis vivendo te, <baz>posse nullam lobortis ex usu</code>. Eam volumus perpetua
constituto id, mea an omittam fierent vituperatoribus.
