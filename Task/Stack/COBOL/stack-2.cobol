       01  node BASED.
         COPY node-info REPLACING
           01 BY 05
           node-info BY info.
         05  link USAGE IS POINTER VALUE NULL.
