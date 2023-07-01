use Socket::Class;

$sock = Socket::Class->new(
  'remote_port' => 256,
) || die Socket::Class->error;
$sock->send('hello socket world');
$sock->free;
