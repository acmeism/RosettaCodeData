(() => {

    // SYSTEM DIRECTORY FUNCTIONS
    // FOR MAC OS 'JAVASCRIPT FOR AUTOMATION' SCRIPTING -----------------------

    // doesDirectoryExist :: String -> IO Bool
    const doesDirectoryExist = strPath => {
        const
            dm = $.NSFileManager.defaultManager,
            ref = Ref();
        return dm
            .fileExistsAtPathIsDirectory(
                $(strPath)
                .stringByStandardizingPath, ref
            ) && ref[0] === 1;
    };

    // doesFileExist :: String -> Bool
    const doesFileExist = strPath => {
        var error = $();
        return (
            $.NSFileManager.defaultManager
            .attributesOfItemAtPathError(
                $(strPath)
                .stringByStandardizingPath,
                error
            ),
            error.code === undefined
        );
    };

    // getCurrentDirectory :: String
    const getCurrentDirectory = () =>
        ObjC.unwrap($.NSFileManager.defaultManager.currentDirectoryPath);

    // getFinderDirectory :: String
    const getFinderDirectory = () =>
        Application('Finder')
        .insertionLocation()
        .url()
        .slice(7);

    // getHomeDirectory :: String
    const getHomeDirectory = () =>
        ObjC.unwrap($.NSHomeDirectory());

    // setCurrentDirectory :: String -> IO ()
    const setCurrentDirectory = strPath =>
        $.NSFileManager.defaultManager
        .changeCurrentDirectoryPath(
            $(strPath)
            .stringByStandardizingPath
        );

    // GENERIC FUNCTIONS FOR THE TEST -----------------------------------------

    // A list of functions applied to a list of arguments
    // <*> :: [(a -> b)] -> [a] -> [b]
    const ap = (fs, xs) => //
        [].concat.apply([], fs.map(f => //
            [].concat.apply([], xs.map(x => [f(x)]))));

    // show :: a -> String
    const show = x => JSON.stringify(x, null, 2);

    // TEST -------------------------------------------------------------------
    return (
        setCurrentDirectory('~/Desktop'),
        show(ap(
            [doesFileExist, doesDirectoryExist],
            ['input.txt', '/input.txt', 'docs', '/docs']
        ))
    );
})();
