load 'strings'

name    =:  'John Q. Public'
shyster =:  'Ed McMahon'
amount  =:  1e6
payment =:  2 * amount
address =:  'Publisher''s Clearing House'

targets =:  ;:   'NAME SHYSTER AMOUNT PAYMENT ADDRESS'
sources =:  ":&.> name;shyster;amount;payment;address

message =: template rplc targets,.sources
