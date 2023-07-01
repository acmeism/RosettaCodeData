#!/usr/bin/rexx
/*.----------------------------------------------------------------------.*/
/*|readconfig: Read keyword value pairs from a configuration file into   |*/
/*|            Rexx variables.                                           |*/
/*|                                                                      |*/
/*|Usage:                                                                |*/
/*|              .-~/rosetta.conf-.                                      |*/
/*|>>-readconfig-+----------------+------------------------------------><|*/
/*|              |-configfilename-|                                      |*/
/*|              |-- -? ----------|                                      |*/
/*|              |-- -h ----------|                                      |*/
/*|              '- --help -------'                                      |*/
/*|                                                                      |*/
/*|where                                                                 |*/
/*|  configfilename                                                      |*/
/*|        is the name of the configuration file to be processed.  if not|*/
/*|        specified, ~/rosetta.conf is used.                            |*/
/*|                                                                      |*/
/*|All values retrieved from the configuration file are stored in        |*/
/*|compound variables with the stem config.  Variables with multiple     |*/
/*|values have a numeric index appended, and the highest index number    |*/
/*|is stored in the variable with index 0; e.g. if CONFIG.OTHERFAMILY.1  |*/
/*|and CONFIG.OTHERFAMILY.2 have values assigned, CONFIG.OTHERFAMILY.0 = |*/
/*|2.                                                                    |*/
/*|-?, -h or --help all cause this documentation to be displayed.        |*/
/*|                                                                      |*/
/*|This program was tested using Open Object Rexx 4.1.1.  It should work |*/
/*|with most other dialects as well.                                     |*/
/*'----------------------------------------------------------------------'*/
  call usage arg(1)
  trace normal
  signal on any name error

/* Prepare for processing the configuration file. */
  keywords = 'FULLNAME FAVOURITEFRUIT NEEDSPEELING SEEDSREMOVED OTHERFAMILY'

/* Set default values for configuration variables here */
  config_single?. = 1
  config. = ''
  config.NEEDSPEELING = 0
  config.SEEDSREMOVED = 1

/* Validate command line inputs. */
  parse arg configfilename

  if length(configfilename) = 0 then
    configfilename = '~/rosetta.conf'

  configfile = stream(configfilename,'COMMAND','QUERY EXISTS')

  if length(configfile) = 0 then
    do
      say configfilename 'was not found.'
      exit 28
    end

  signal on notready                               /* if an I/O error occurs. */

/* Open the configuration file. */
  response = stream(configfile,'COMMAND','OPEN READ SHARED')

/* Parse the contents of the configuration file into variables. */
  do while lines(configfile) > 0
    statement = linein(configfile)

    select
      when left(statement,1) = '#',
         | left(statement,1) = ';',
         | length(strip(statement)) = 0,
      then                                      /* a comment or a blank line. */
        nop                                                       /* skip it. */

      otherwise
        do
          if pos('=',word(statement,1)) > 0,
           | left(word(statement,2),1) = '=',
          then                        /* a keyword/value pair with = between. */
            parse var statement keyword '=' value

          else                             /* a keyword/value pair with no =. */
            parse var statement keyword value

          keyword = translate(strip(keyword))           /* make it uppercase. */
          single? = pos(',',value) = 0 /* a single value, or multiple values? */
          call value 'CONFIG_single?.'keyword,single?          /* remember. */

          if single? then
            do
              if length(value) > 0 then
                call value 'CONFIG.'keyword,strip(value)
            end                      /* strip keeps internal whitespace only. */

          else                            /* store each value with its index. */
            do v = 1 by 1 while length(value) > 0
              parse var value value1 ',' value

              if length(value1) > 0 then
                do
                  call value 'CONFIG.'keyword'.'v,strip(value1)
                  call value 'CONFIG.'keyword'.0',v         /* remember this. */
                end
            end
        end
    end
  end

/* Display the values of the configuration variables. */
  say 'Values associated with configuration file' configfilename':'
  say

  do while words(keywords) > 0
    parse var keywords keyword keywords

    if value('CONFIG_single?.'keyword) then
      say right(keyword,20) '= "'value('CONFIG.'keyword)'"'

    else
      do
        lastv = value('CONFIG.'keyword'.0')

        do v = 1 to lastv
          say right(keyword,20-(length(v)+2))'['v'] = "'value('CONFIG.'keyword'.'v)'"'
        end
      end
  end

  say

notready:                                           /* I/O errors come here. */
  filestatus = stream(configfile,'STATE')

  if filestatus \= 'READY' then
    say 'An I/O error occurred; the file status is' filestatus'.'

  response = stream(configfile,'COMMAND','CLOSE')

error:
/*? = sysdumpvariables() */                    /* see everything Rexx used. */
exit

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
        say text
      end

      say
      exit 0
    end
return
