let students_xml = readfile('XML-Input.xml')
call filter(students_xml, 'v:val =~ "<Student "')
let s:s_pat = '\v^.+(Name\=")@<=([A-z&#x0-9;]+).+'
let s:s_sub = '\2'
call map(students_xml, {_, val -> substitute(val, s:s_pat, s:s_sub, 'g')})
let s:s_pat = '\c\v\&#x0*([a-f][[:xdigit:]]|[[:xdigit:]]{3,7});'
let s:s_sub = '\=nr2char(str2nr(submatch(1), 16), 1)'
call map(students_xml, {_, val -> substitute(val, s:s_pat, s:s_sub, 'g')})
echo students_xml->writefile('XML-input.out.txt')
