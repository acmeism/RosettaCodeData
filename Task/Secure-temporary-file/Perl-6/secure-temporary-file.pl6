use File::Temp;

# Generate a temp file in a temp dir
my ($filename0,$filehandle0) = tempfile;

# specify a template for the filename
#  * are replaced with random characters
my ($filename1,$filehandle1) = tempfile("******");

# Automatically unlink files at DESTROY (this is the default)
my ($filename2,$filehandle2) = tempfile("******", :unlink);

# Specify the directory where the tempfile will be created
my ($filename3,$filehandle3) = tempfile(:tempdir("/path/to/my/dir"));

# don't unlink this one
my ($filename4,$filehandle4) = tempfile(:tempdir('.'), :!unlink);

# specify a prefix, a suffix, or both for the filename
my ($filename5,$filehandle5) = tempfile(:prefix('foo'), :suffix(".txt"));
