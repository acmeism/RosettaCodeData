require 'strings web/gethttp'

findUnimpTasks=: ('Programming_Tasks' -.&getCategoryMembers ,&'/Omit') ([ #~ -.@e.) getCategoryMembers

getTagContents=: dyad define
  'starttag endtag'=. x
  ('\' -.~ endtag&taketo)&.>@(starttag&E. <@((#starttag)&}.);.1 ]) y
)

NB. RosettaCode Utilities
parseTitles=: ('"title":"';'"')&getTagContents
parseCMcontinue=:('"cmcontinue":"';'"')&getTagContents
getCMcontquery=: ('&cmcontinue=' , urlencode)^:(0 < #)@>@parseCMcontinue

getCategoryMembers=: monad define
  buildqry=. 'action=query&list=categorymembers&cmtitle=Category:' , ,&'&cmlimit=500&format=json'
  url=.'http://www.rosettacode.org/w/api.php'
  uri=. url ,'?', buildqry urlencode y
  catmbrs=. qrycont=. ''
  whilst. #qrycont=. getCMcontquery jsondat do.
    jsondat=. gethttp uri , qrycont
    catmbrs=. catmbrs, parseTitles jsondat
  end.
  catmbrs
)
