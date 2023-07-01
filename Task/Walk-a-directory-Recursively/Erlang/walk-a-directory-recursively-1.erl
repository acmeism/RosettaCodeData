walk_dir(Path, Pattern) ->
        filelib:fold_files(
                Path,
                Pattern,
                true, % Recurse
                fun(File, Accumulator) -> [File|Accumulator] end,
                []
        )
