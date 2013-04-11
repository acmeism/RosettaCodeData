use Plack::Runner;
my $app = sub {
    return [ 200,
	     [ 'Content-Type' => 'text/html; charset=UTF-8' ],
	     [ '<html><head><title>Goodbye, world!</title></head><body>Goodbye, world!</body></html>' ]
	   ]
};
my $runner = Plack::Runner->new;
$runner->parse_options('--host' => 'localhost', '--port' => 8080);
$runner->run($app);
