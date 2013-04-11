use Digest::MD5;

$md5 = Digest::MD5->new;
$md5->add("The quick brown fox jumped over the lazy dog's back");
print $md5->hexdigest, "\n";
