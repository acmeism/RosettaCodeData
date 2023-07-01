require 'io/console'

def yesno
  case $stdin.getch
    when "Y" then true
    when "N" then false
    else raise "Invalid character."
  end
end
