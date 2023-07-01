import printf from 'printf' // Module must be installed with npm first
import * as gray from './gray-code.js'

console.log(
    'Number\t' +
    'Binary\t' +
    'Gray Code\t' +
    'Decoded Gray Code'
)

for (let number = 0; number < 32; number++) {
    const grayCode = gray.encode(number)
    const decodedGrayCode = gray.decode(grayCode)

    console.log(printf(
        '%2d\t%05d\t%05d\t\t%2d',
        number,
        number.toString(2),
        grayCode.toString(2),
        decodedGrayCode
    ))
}
