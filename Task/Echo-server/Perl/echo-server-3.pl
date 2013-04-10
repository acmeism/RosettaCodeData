package Echo;
use base 'Net::Server::PreFork';
sub process_request {
    print while <STDIN>;
}
Echo->run(port => 12321, log_level => 3);
