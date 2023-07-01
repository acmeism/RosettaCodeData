use Socket;

$host = gethostbyname('localhost');
$in = sockaddr_in(256, $host);
$proto = getprotobyname('tcp');
socket(Socket_Handle, AF_INET, SOCK_STREAM, $proto);
connect(Socket_Handle, $in);
send(Socket_Handle, 'hello socket world', 0, $in);
close(Socket_Handle);
