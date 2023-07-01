#!/usr/bin/rexx
/*.----------------------------------------------------------------------.*/
/*|bashcolours: Display a table showing all of the possible colours that |*/
/*|             can be generated using ANSI escapes in bash in an xterm  |*/
/*|             terminal session.                                        |*/
/*|                                                                      |*/
/*|Usage:                                                                |*/
/*|                                                                      |*/
/*|>>-bashcolours-.----------.-----------------------------------------><|*/
/*|               |-- -? ----|                                           |*/
/*|               |-- -h ----|                                           |*/
/*|               '- --help -'                                           |*/
/*|                                                                      |*/
/*|where                                                                 |*/
/*|  -?, -h or --help                                                    |*/
/*|         display this documentation.                                  |*/
/*|                                                                      |*/
/*|This program is based on the shell script in the Bash Prompt HowTo at |*/
/*|http://www.tldp.org/, by Giles Orr.                                   |*/
/*|                                                                      |*/
/*|This program writes the various colour codes to the terminal to       |*/
/*|demonstrate what's available.  Each line showshe colour code of one   |*/
/*|forground colour, out of 17 (default + 16 escapes), followed by a test|*/
/*|use of that colour on all nine background colours (default + 8        |*/
/*|escapes).  Additional highlighting escapes are also demonstrated.     |*/
/*|                                                                      |*/
/*|This program uses object-oriented features of Open Object Rexx.       |*/
/*|The lineout method is used instead of say for consistency with use of |*/
/*|the charout method.                                                   |*/
/*'----------------------------------------------------------------------'*/
  call usage arg(1)
  trace normal

/* See if escapes work on the kind of terminal in use. */
  if value('TERM',,'ENVIRONMENT') = 'LINUX' then
    do
      say 'The Linux console does not support ANSI escape sequences for',
          'changing text colours or highlighting.'
      exit 4
    end

/* Set up the escape sequences. */
  ! = '1B'x                                                  -- ASCII escape
  bg = .array~of('[40m','[41m','[42m','[43m','[44m','[45m','[46m','[47m')
  fg = .array~of('[0m',   '[1m',   '[0;30m','[1;30m','[0;31m','[1;31m',,
                 '[0;32m','[1;32m','[0;33m','[1;33m','[0;34m','[1;34m',,
                 '[0;35m','[1;35m','[0;36m','[1;36m','[0;37m','[1;37m')
  hi = .array~of('[4m','[5m','[7m','[8m')
  text = 'gYw'                                              -- The test text
  .OUTPUT~lineout(' ')
  .OUTPUT~lineout('Foreground  |       Background Codes')
  .OUTPUT~lineout(!'[4mCodes       '!'[0m|'||,
                  !'[4m~[40m ~[41m ~[42m ~[43m ~[44m ~[45m ~[46m ~[47m'!'[0m')

  do f = 1 to fg~size                          -- write the foreground info.
    prefix = '~'fg[f]~left(6)' '!||fg[f]~strip' 'text
    .OUTPUT~charout(prefix)

    do b = 1 to bg~size                        -- write the background info.
      segment = !||fg[f]~strip !||bg[b]' 'text' '!||fg[1]
      .OUTPUT~charout(segment)
    end

    .OUTPUT~lineout(' ')
  end

/* Write the various highlighting escape sequences. */
  prefix = '~[4m'~left(6)'   '!||hi[1]'Underlined'!||fg[1]
  .OUTPUT~lineout(prefix)
  prefix = '~[5m'~left(6)'   '!||hi[2]'Blinking'!||fg[1]
  .OUTPUT~lineout(prefix)
  prefix = '~[7m'~left(6)'   '!||hi[3]'Inverted'!||fg[1]
  .OUTPUT~lineout(prefix)
  prefix = '~[8m'~left(6)'   '!||hi[4]'Concealed'!||fg[1],
           "(Doesn't seem to work in my xterm; might in Windows?)"
  .OUTPUT~lineout(prefix)
  .OUTPUT~lineout(' ')
  .OUTPUT~lineout("Where ~ denotes the ASCII escape character ('1B'x).")
  .OUTPUT~lineout(' ')
exit

/*.--------------------------------------------------------.*/
/*|One might expect to be able to use directory collections|*/
/*|as below instead of array collections, but there is no  |*/
/*|way to guarantee that a directory's indices will be     |*/
/*|iterated over in a consistent sequence, since directory |*/
/*|objects are not ordered.  Oh, well...                   |*/
/*'--------------------------------------------------------'*/
  fg = .directory~new
  fg[Default]   = '[0m';    fg[DefaultBold] = '[1m'
  fg[Black]     = '[0;30m'; fg[DarkGray]    = '[1;30m'
  fg[Blue]      = '[0;34m'; fg[LightBlue]   = '[1;34m'
  fg[Green]     = '[0;32m'; fg[LightGreen]  = '[1;32m'
  fg[Cyan]      = '[0;36m'; fg[LightCyan]   = '[1;36m'
  fg[Red]       = '[0;31m'; fg[LightRed]    = '[1;31m'
  fg[Purple]    = '[0;35m'; fg[LightPurple] = '[1;35m'
  fg[Brown]     = '[0;33m'; fg[Yellow]      = '[1;33m'
  fg[LightGray] = '[0;37m'; fg[White]       = '[1;37m'
  bg = .directory~new;      hi = .directory~new
  bg[Black]     = '[0;40m'; hi[Underlined]  = '[4m'
  bg[Blue]      = '[0;44m'; hi[Blinking]    = '[5m'
  bg[Green]     = '[0;42m'; hi[Inverted]    = '[7m'
  bg[Cyan]      = '[0;46m'; hi[Concealed]   = '[8m'
  bg[Red]       = '[0;41m'
  bg[Purple]    = '[0;45m'
  bg[Brown]     = '[0;43m'
  bg[LightGray] = '[0;47m'

usage: procedure
  trace normal

  if arg(1) = '-h',
   | arg(1) = '-?',
   | arg(1) = '--help'
  then
    do
      line = '/*|'
      say

      do l = 3 by 1 while line~left(3) = '/*|'
        line = sourceline(l)
        parse var line . '/*|' text '|*/' .
        .OUTPUT~lineout(text)
      end

      say
      exit 0
    end
return
