use strict;
use LWP::UserAgent;
use HTTP::Request;

sub send_email {
  my ($from, $to, $cc, $subject, $text) = @_;

  my $ua = LWP::UserAgent->new;
  my $req = HTTP::Request->new (POST => "mailto:$to",
                                [ From => $from,
                                  Cc => $cc,
                                  Subject => $subject ],
                                $text);
  my $resp = $ua->request($req);
  if (! $resp->is_success) {
    print $resp->status_line,"\n";
  }
}

send_email('from-me@example.com', 'to-foo@example.com', '',
           "very important subject",
           "Body text\n");
