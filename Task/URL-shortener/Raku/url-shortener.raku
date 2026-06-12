# Persistent URL storage
use JSON::Fast;

my $urlfile = './urls.json'.IO;
my %urls = ($urlfile.e and $urlfile.f and $urlfile.s) ??
  ( $urlfile.slurp.&from-json ) !!
  ( index => 1, url => { 0 => 'http://rosettacode.org/wiki/URL_shortener#Raku' } );

$urlfile.spurt(%urls.&to-json);

# Setup parameters
my $host = 'localhost';
my $port = 10000;

# Micro HTTP service
use Cro::HTTP::Router;
use Cro::HTTP::Server;

my $application = route {
    post -> 'add_url' {
        redirect :see-other, '/';
        request-body -> (:$url) {
            %urls<url>{ %urls<index>.base(36) } = $url;
            ++%urls<index>;
            $urlfile.spurt(%urls.&to-json);
        }
    }

    get -> {
        content 'text/html', qq:to/END/;
        <form action="http://$host:$port/add_url" method="post">
        URL to add:</br><input type="text" name="url"></br>
        <input type="submit" value="Submit"></form></br>
        Saved URLs:
        <div style="background-color:#eeeeee">
        { %urls<url>.sort( +(*.key.parse-base(36)) ).join: '</br>' }
        </div>
        END
    }

    get -> $short {
        if my $link = %urls<url>{$short} {
            redirect :permanent, $link
        }
        else {
            not-found
        }
    }
}

my Cro::Service $shorten = Cro::HTTP::Server.new:
    :$host, :$port, :$application;

$shorten.start;

react whenever signal(SIGINT) { $shorten.stop; exit; }
