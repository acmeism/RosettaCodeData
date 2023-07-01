% Collect every file in the current directory
walkdir:walk_dir(".", ".*").

% Collect every file my .config folder that ends with `rc`
walkdir:walk_dir("/home/me/.config/", ".*rc$").
