include Setting

arg lang
if lang = '' then
   lang = 'EN'
else
   lang = Translate(lang)
select
   when lang = 'NL' then do
      NLstem.1 = 'Hallo wereld!'; NLstem.2 = 'Hoe gaat het met je?'; NLstem.3 = 'Tot ziens!'
      Call NL
   end
   when lang = 'DE' then do
      DEstem.1 = 'Hallo Welt!'; DEstem.2 = 'Wie geht es euch?'; DEstem.3 = 'Bis bald!'
      Call DE
   end
   when lang = 'EN' then do
      ENstem.1 = 'Hello world!'; ENstem.2 = 'How are you doing?'; ENstem.3 = 'See you soon!'
      Call EN
   end
   otherwise
      say 'Choose language NL, DE or EN'
end
exit 0

include Rundemo [lang]=NL
include Rundemo [lang]=DE
include Rundemo

include Abend
