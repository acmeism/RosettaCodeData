(sample => {

    // mean :: [Num] => (Num | NaN)
    let mean = lst => {
        let lng = lst.length;

        return lng ? (
            lst.reduce((a, b) => a + b, 0) / lng
        ) : NaN;
    };

    return mean(sample);

})([1, 2, 3, 4, 5, 6, 7, 8, 9]);
