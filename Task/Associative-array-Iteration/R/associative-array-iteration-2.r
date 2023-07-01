> index <- "1"
> env[[index]] <- "rainfed hay"
> for (name in ls(env)) {
+   cat(sprintf('index=%s, value=%s\n', name, env[[name]]))
+ }
