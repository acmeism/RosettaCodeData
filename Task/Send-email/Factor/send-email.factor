USING: accessors io.sockets locals namespaces smtp ;
IN: scratchpad
:: send-mail ( f t c s b -- )
    default-smtp-config "smtp.gmail.com" 587 <inet> >>server
    t >>tls?
    "my.gmail.address@gmail.com" "qwertyuiasdfghjk" <plain-auth>
    >>auth \ smtp-config set-global <email> f >>from t >>to
    c >>cc s >>subject b >>body send-email ;
