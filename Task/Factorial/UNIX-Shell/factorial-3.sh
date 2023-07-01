factorial ()
{
  if [ $1 -eq 0 ]
    then echo 1
    else echo $(($1 * $(factorial $(($1-1)) ) ))
  fi
}
