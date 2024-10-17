$ ocaml
# #use "topfind";;
# #require "netstring";;

# Netencoding.Url.decode "http%3A%2F%2Ffoo%20bar%2F" ;;
- : string = "http://foo bar/"
