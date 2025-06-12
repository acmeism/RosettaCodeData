function naturalSort(a, b) => {
    return a.trim().localeCompare(b.trim(), 'und', { numeric: true })
}

const files = ['file10.txt', '\nfile9.txt', 'File11.TXT', 'file12.txt']
console.log(files.toSorted(naturalSort))
// ['\nfile9.txt', 'file10.txt', 'File11.TXT', 'file12.txt']
