-- Module Setting.inc - 9 Oct 2025
-- Settings valid for all modules and procedures

signal on error name Abend
signal on halt name Abend
signal on notready name Abend
signal on novalue name Abend
signal on syntax name Abend
parse version version; parse source system command program
run! = 'rundemo.rex'
Glob.=''; Memo.=''
Glob.ooRexx=(Pos('ooRexx',version)>0); Glob.Regina=(Pos('Regina',version)>0)
Glob.mintime=1; Glob.maxtime=60; Glob.timer=Time('L'); Glob.elaps=Glob.timer
call Time 'R'

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

NL:
procedure expose NLstem.
do n = 1 to 3
   say NLstem.n
end
return

DE:
procedure expose DEstem.
do n = 1 to 3
   say DEstem.n
end
return

EN:
procedure expose ENstem.
do n = 1 to 3
   say ENstem.n
end
return


-- Module Abend.inc - 9 Oct 2025
-- Condition, abend, assertion and argument error handler
-- Debugging routines and display program stack
-- All vars are global having names ending with !

Abend:
-- Condition and abend handler
-- -> condition info
trace off
signal off error
signal off halt
signal off notready
signal off novalue
signal off syntax
parse version version!; parse source . . program!
run! = 'rundemo.rex'
sigl!=sigl; cc!=Condition('c'); cd!=Condition('d')
if rc<>16 then
   call ShowSource
call ShowModule
call ShowLabel
call ShowLine
call ShowVars
if rc<>16 then
   call ShowSignal
signal on novalue name IgnoreError16
say; say IgnoreError16
return

Assert:
-- Handle assertion
-- -> assertion info
arg x!,.
if x!=1 then
   return 0
parse version version!; parse source . . program!
run! = 'rundemo.rex'
sigl!=sigl
call ShowSource
call ShowModule
call ShowLabel
call ShowLine
call ShowVars
call ShowSignal
exit 1

Debug:
-- Show line and variables
-- -> source and variable info
say
sigl!=sigl
call ShowLine
call ShowVars
return

Showsource:
-- Show rexx and source info
-- -> run and source info
say
say 'Rexx   :' version!
say 'Run    :' run!
say 'Source :' program!
return

Showmodule:
-- Show active module
-- -> module
do sl!=sigl! by -1 to 1 until m!='Module' & n!<>'Setting.inc'
   s!=Strip(SourceLine(sl!))
   parse var s! a! m! n! t!
end sl!
parse var n! n!'.'.
if sl!>0 then
   say 'Module :' sl! n! t!
return

Showlabel:
-- Show active procedure or routine
-- -> label
do sl!=sigl! by -1 to 1 until Right(l!,1)=':'
   l!=Strip(SourceLine(sl!))
end sl!
parse var l! l!':'.
if sl!>0 then do
   p!=''
   do sp!=sl! for 5
      a!=Strip(SourceLine(sp!))
      if Word(a!,1)='procedure' then
         p!=a!
   end sp!
   say 'Label  :' sl! l! p!
end
return

Showline:
-- Show line
-- -> lineno and source
s!=Strip(SourceLine(sigl!))
say 'Line   :' sigl! s!
return

Showvars:
-- Show arguments or variables
-- -> arguments or variables
-- Collect
v!.=0; s!=Upper(s!)
s!=Translate(s!,"                ","+-*|<>,;=/\%()'")
if WordPos('EXPOSED',s!)>0 then
   return
do i!=1 to Words(s!)
   w!=Word(s!,i!)
   if Symbol(w!)='VAR' then do
      call SaveVar
      if Pos('.',w!)>0 then do
         t!=Translate(w!," ",".")
         do j!=2 to Words(t!)
            w!=Word(t!,j!)
            if Symbol(w!)='VAR' then
               call SaveVar
         end j!
      end
   end
end i!
-- Show
do i!=1 to v!.0
   v!=v!.i!; a!=Value(v!)
   if WordPos('ARGUMENT',s!)>0 then
      say 'Arg    :' v! '=' ''''a!''''
   else
      say 'Var    :' v! '=' ''''a!''''
end i!
return

Showsignal:
-- Signal
-- -> signal, error and reason
-- Set text
select
   when WordPos('ARGUMENT',s!)>0 then
      cc!='Argument outside domain, invalid or missing'
   when WordPos('ASSERT',s!)>0 then
      cc!='Assertion is falsified'
   when WordPos('EXPOSED',s!)>0 then
      cc!='Expose is missing on this or a higher level'
   when WordPos('STACK',s!)>0 then
      cc!='Program call stack display forced by user'
   when cc!='ERROR' then
      cc!='External command is not recognized or has failed'
   when cc!='HALT' then
      cc!='Program interrupted by user'
   when cc!='NOTREADY' then
      cc!='File does not exist or is in use by another app'
   when cc!='NOVALUE' then
      cc!='Variable has no value'
   when cc!='SYNTAX' then
      cc!='Runtime error'
   otherwise
      cc!=''
end
-- Show
if cc!<>'' then
   say 'Signal :' cc!
if WordPos('ARGUMENT',s!)>0 then
   return
if WordPos('ASSERT',s!)>0 then
   return
if WordPos('EXPOSED',s!)>0 then
   return
if WordPos('STACK',s!)>0 then
   return
if DataType(rc)='NUM' then
   if rc>0 then
      say 'Error  :' rc ErrorText(rc)
if cd!<>'' then
   if cd!<>'SIGINT' then
      say 'Reason :' cd!
return

Savevar:
-- Save variable
do k!=1 to v!.0
   if w!=v!.k! then
      leave
end k!
if k!>v!.0 then do
   v!.k!=w!; v!.0=k!
end
return

-- --------------------------------------------------
-- MODULE SUMMARY          Date and Time        Lines
-- --------------------------------------------------
-- rundemo.rex             21 Aug 2025 17:54:04    30
-- \Rex\Public\Setting.inc  9 Oct 2025 15:00:13    13
-- Rundemo.inc              9 Oct 2025 17:59:56     8
-- Rundemo.inc              9 Oct 2025 17:59:56     8
-- Rundemo.inc              9 Oct 2025 17:59:56     8
-- \Rex\Public\Abend.inc    9 Oct 2025 14:59:40   186
-- --------------------------------------------------
-- 8ms                      9 Oct 2025 18:15:34   261
-- --------------------------------------------------
