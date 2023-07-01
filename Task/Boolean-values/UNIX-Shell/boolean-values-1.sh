if
  echo 'Looking for file'  # This is the evaluation block
  test -e foobar.fil       # The exit code from this statement determines whether the branch runs
then
  echo 'The file exists'   # This is the optional branch
  echo 'I am going to delete it'
  rm foobar.fil
fi
