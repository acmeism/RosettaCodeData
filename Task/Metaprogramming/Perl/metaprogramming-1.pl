package UnicodeEllipsis;

use Filter::Simple;

FILTER_ONLY code => sub { s/…/../g };
