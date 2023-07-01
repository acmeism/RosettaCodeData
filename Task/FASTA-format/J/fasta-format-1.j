require 'strings'  NB. not needed for J versions greater than 6.
parseFasta=: ((': ' ,~ LF&taketo) , (LF -.~ LF&takeafter));._1
