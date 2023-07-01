/**
 * [wordwrap description]
 * @param  {[type]}  text  [description]
 * @param  {Number}  width [description]
 * @param  {String}  br    [description]
 * @param  {Boolean} cut   [description]
 * @return {[type]}        [description]
 */
function wordwrap(text, width = 80, br = '\n', cut = false) {
  // Приводим к uint
  // 0..2^32-1 либо 0..2^64-1
  width >>>= 0;
  // Длина текста меньше или равна максимальной
  if (0 === width || text.length <= width) {
    return text;
  }
  // Разбиваем текст на строки
  return text.split('\n').map(line => {
    if (line.length <= width) {
      return line;
    }
    // Разбиваем строку на слова
    let words = line.split(' ');
    // Если требуется, то обрезаем длинные слова
    if (cut) {
      let temp = [];
      for (const word of words) {
        if (word.length > width) {
          let i = 0;
          const length = word.length;
          while (i < length) {
            temp.push(word.slice(i, Math.min(i + width, length)));
            i += width;
          }
        } else {
          temp.push(word);
        }
      }
      words = temp;
    }
    // console.log(words);
    // Собираем новую строку
    let wrapped = words.shift();
    let spaceLeft = width - wrapped.length;
    for (const word of words) {
      if (word.length + 1 > spaceLeft) {
        wrapped += br + word;
        spaceLeft = width - word.length;
      } else {
        wrapped += ' ' + word;
        spaceLeft -= 1 + word.length;
      }
    }
    return wrapped;
  }).join('\n'); // Объединяем элементы массива по LF
}
