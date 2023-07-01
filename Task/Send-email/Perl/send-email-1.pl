use Net::SMTP;
use Authen::SASL;
  # Net::SMTP's 'auth' method needs Authen::SASL to work, but
  # this is undocumented, and if you don't have the latter, the
  # method will just silently fail. Hence we explicitly use
  # Authen::SASL here.

sub send_email {
  my %o =
     (from => '', to => [], cc => [],
      subject => '', body => '',
      host => '', user => '', password => '',
      @_);
  ref $o{$_} or $o{$_} = [$o{$_}] foreach 'to', 'cc';

  my $smtp = Net::SMTP->new($o{host} ? $o{host} : ())
      or die "Couldn't connect to SMTP server";

  $o{password} and
     $smtp->auth($o{user}, $o{password}) ||
     die 'SMTP authentication failed';

  $smtp->mail($o{user});
  $smtp->recipient($_) foreach @{$o{to}}, @{$o{cc}};
  $smtp->data;
  $o{from} and $smtp->datasend("From: $o{from}\n");
  $smtp->datasend('To: ' . join(', ', @{$o{to}}) . "\n");
  @{$o{cc}} and $smtp->datasend('Cc: ' . join(', ', @{$o{cc}}) . "\n");
  $o{subject} and $smtp->datasend("Subject: $o{subject}\n");
  $smtp->datasend("\n$o{body}");
  $smtp->dataend;

  return 1;
}
