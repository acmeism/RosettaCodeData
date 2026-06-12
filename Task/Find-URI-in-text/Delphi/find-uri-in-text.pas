program Find_URI_in_text;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.RegularExpressions;

const
  pattern = '(*UTF)(*UCP)' +                    // Make \w unicode aware
    '(?<URI>[a-z][-a-z0-9+.]*:' +              // Scheme...
    '(?=[/\w])' +                      // ... but not just the scheme
    '(?://[-\w.@:]+)?)' +               // Host
    '[-\w.~/%!$&''()*+,;=]*' +          // Path
    '(?:\?[-\w.~%!$&''()*+,;=/?]*)?' + // Query
    '(?:\#[-\w.~%!$&''()*+,;=/?]*)?';   // Fragment

  Text =
    'this URI contains an illegal character, parentheses and a misplaced full stop:' + #13#10 +
    'http://en.wikipedia.org/wiki/Erich_Kästner_(camera_designer). ' +
    '(which is handled by http://mediawiki.org/).' + #13#10 +
    'and another one just to confuse the parser: http://en.wikipedia.org/wiki/-)' + #13#10 +
    '")" is handled the wrong way by the mediawiki parser.' + #13#10 +
    'ftp://domain.name/path(balanced_brackets)/foo.html' + #13#10 +
    'ftp://domain.name/path(balanced_brackets)/ending.in.dot.' + #13#10 +
    'ftp://domain.name/path(unbalanced_brackets/ending.in.dot.' + #13#10 +
    'leading junk ftp://domain.name/path/embedded?punct/uation.' + #13#10 +
    'leading junk ftp://domain.name/dangling_close_paren)' + #13#10 +
    'if you have other interesting URIs for testing, please add them here:' + #13#10 +
    'http://www.example.org/foo.html#includes_fragment' + #13#10 +
    'http://www.example.org/foo.html#enthält_Unicode-Fragment';

var
  reg: TRegEx;
  Match: TMatch;
  IRIs: string = '';
  URIs: string = '';

begin
  reg := TRegEx.Create(pattern);
  for Match in reg.Matches(Text) do
  begin
    URIs := URIs + #10 + Match.Groups['URI'].Value;
    IRIs := IRIs + #10 + Match.Value;
  end;

  Write('URIs:-');
  Writeln(URIs, #10);

  Write('IRIs:-');
  Writeln(IRIs, #10);

  Readln;
end.
