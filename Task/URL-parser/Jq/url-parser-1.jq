# See Appendix B of RFC 3986
def URL:
  capture("^((?<scheme>[^:/?#]+):)?(//(?<authority>[^/?#]*))?(?<path>[^?#]*)(\\?(?<query>[^#]*))?(#(?<fragment>.*))?");

# The authority could be of the form: [username:password@]domain[:port]
def authority:
 capture( "^((?<username>[^:@/]*):(?<password>[^@]*)@)?(?<domain>[^:?]*)(:(?<port>[0-9]*))?$" );

# The following filter first parses a valid URL into the five basic
# components, producing a JSON object with five keys; if the "authority"
# field can be futher parsed by `authority`, it is replaced by the
# corresponding JSON object.
def uri:
  URL
  | if .authority
    then (.authority|authority) as $authority
    | if $authority then .authority |= $authority
      else .
      end
    else .
    end;
