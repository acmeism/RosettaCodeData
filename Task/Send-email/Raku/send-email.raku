use Email::Simple;

my $to      = 'mail@example.com';
my $from    = 'me@example.com';
my $subject = 'test';
my $body    = 'This is a test.';

my $email = Email::Simple.create(
    :header[['To', $to], ['From', $from], ['Subject', $subject]],
    :body($body)
);

say ~$email;

# Note that the following will fail without an actual smtp server that
# will accept anonymous emails on port 25 (Not very common anymore).
# Most public email servers now require authentication and encryption.

my $smtp-server = 'smtp.example.com';
my $smtp-port   = 25;

await IO::Socket::Async.connect($smtp-server, $smtp-port).then(
    -> $smtp {
        if $smtp.status {
            given $smtp.result {
                react {
                    whenever .Supply() -> $response {
                        if $response ~~ /^220/ {
                            .print( join "\r\n",
                                "EHLO $smtp-server",
                                "MAIL FROM:<{$email.from}>",
                                "RCPT TO:<{$email.to}>",
                                "DATA", $email.body,
                                '.', ''
                            )
                        }
                        elsif $response ~~ /^250/ {
                            .print("QUIT\r\n");
                            done
                        }
                        else {
                           say "Send email failed with: $response";
                           done
                        }
                    }
                    .close
                }
            }
        }
    }
)
