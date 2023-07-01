parse arg aaa                          /*get the arguments.        */
                                       /*another version:          */
                                       /*  aaa=arg(1)              */
say 'command arguments:'
say aaa

opts=''                                /*placeholder for options.  */
data=''                                /*placeholder for data.     */

  do j=1 to words(aaa)
  x=word(aaa,j)
  if left(x,1)=='-' then opts=opts x   /*Option?  Then add to opts.*/
                    else data=data x   /*Must be data. Add to data.*/
  end

        /*the above process adds a leading blank to  OPTS and  DATA*/

opts=strip(opts,'L')                   /*strip leading blanks.     */
data=strip(data,'l')                   /*strip leading blanks.     */
say
say 'options='opts
say '   data='data
