use Gumbo;
use LWP::Simple;
use XML::Text;

class YahooSearch {
  has $!dom;

  submethod BUILD (:$!dom) { }

  method new($term) {
    self.bless(
      dom => parse-html(
        LWP::Simple.get("http://search.yahoo.com/search?p={ $term }")
      )
    );
  }

  method next {
    $!dom = parse-html(
      LWP::Simple.get(
        $!dom.lookfor( TAG => 'a', class => 'next' ).head.attribs<href>
      )
    );
    self;
  }

  method text ($node) {
    return ''         unless $node;
    return $node.text if     $node ~~ XML::Text;

    $node.nodes.map({ self.text($_).trim }).join(' ');
  }

  method results {
    state $n = 0;
    for $!dom.lookfor( TAG => 'h3', class => 'title') {
      given .lookfor( TAG => 'a' )[0] {
        next unless $_;                                               # No Link
        next if .attribs<href> ~~ / ^ 'https://r.search.yahoo.com' /; # Ad
        say "=== #{ ++$n } ===";
        say "Title: { .contents[0] ?? self.text( .contents[0] ) !! '' }";
        say "  URL: { .attribs<href> }";

        my $pt = .parent.parent.parent.elements( TAG => 'div' ).tail;
        say " Text: { self.text($pt) }";
      }
    }
    self;
  }

}

sub MAIN (Str $search-term) is export {
  YahooSearch.new($search-term).results.next.results;
}
