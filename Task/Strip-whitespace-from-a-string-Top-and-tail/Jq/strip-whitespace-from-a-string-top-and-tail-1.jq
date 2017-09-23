def lstrip: sub( "^[\\s\\p{Cc}]+"; "" );

def rstrip: sub( "[\\s\\p{Cc}]+$"; "" );

def strip: lstrip | rstrip;
