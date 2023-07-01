# 20220103 Raku programming solution

use NativeCall;

sub CannyEdgeDetector(CArray[uint8], CArray[uint8], num64, num64, num64, num64
) returns int32 is native( '/home/hkdtam/LibCannyEdgeDetector.so' ) {*};

CannyEdgeDetector( # imagemagick.org/script/command-line-options.php#canny
   CArray[uint8].new(  'input.jpg'.encode.list, 0), # pbs.org/wgbh/nova/next/wp-content/uploads/2013/09/fingerprint-1024x575.jpg
   CArray[uint8].new( 'output.jpg'.encode.list, 0),
   0e0, 2e0, 0.05e0, 0.05e0
)
