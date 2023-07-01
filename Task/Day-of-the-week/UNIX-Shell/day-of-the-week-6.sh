zmodload zsh/datetime
for (( year = 2010; year <= 2121; year++ ));
  if [[ $(strftime '%A' $(strftime -r '%F' $year-12-25)) == Sunday ]] print $year
