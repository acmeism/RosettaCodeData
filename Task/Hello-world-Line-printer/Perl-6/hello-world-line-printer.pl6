given open '/dev/lp0', :w { # Open the device for writing as the default
    .say('Hello World!');              # Send it the string
    .close;
#   ^ The prefix "." says "use the default device here"
}
