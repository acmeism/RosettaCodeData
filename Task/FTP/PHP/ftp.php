$server = "speedtest.tele2.net";
$user = "anonymous";
$pass = "ftptest@example.com";

$conn = ftp_connect($server);
if (!$conn) {
    die('unable to connect to: '. $server);
}
$login = ftp_login($conn, $user, $pass);
if (!$login) {
    echo 'unable to log in to '. $server. ' with user: '.$user.' and pass: '. $pass;
} else{
    echo 'connected successfully'.PHP_EOL;
    $directory = ftp_nlist($conn,'');
    print_r($directory);
}
if (ftp_get($conn, '1KB.zip', '1KB.zip', FTP_BINARY)) {
    echo "Successfully downloaded file".PHP_EOL;
} else {
    echo "failed to download file";
}
