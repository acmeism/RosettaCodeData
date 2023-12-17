let rec mkdir_p path perm =
 if path <> "" then
    try Unix.mkdir path perm with
    | Unix.Unix_error (EEXIST, _, _) when Sys.is_directory path -> ()
    | Unix.Unix_error (ENOENT, _, _) ->
      mkdir_p (Filename.dirname path) perm;
      Unix.mkdir path perm
