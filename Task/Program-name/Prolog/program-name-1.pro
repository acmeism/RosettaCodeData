% SWI-Prolog version 8.0.0 for i686-linux.
% This will find itself, and return the knowledge base it is in.
file_name(F) :- true
   , M = user            % M is the module    .
   , P = file_name(_)    % P is the predicate .
   , source_file(M:P, F) % F is the file      .
   , \+ predicate_property(M:P, imported_from(_))
   .
