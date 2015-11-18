date = new Date

console.log date.toLocaleDateString 'en-GB',
    month:  '2-digit'
    day:    '2-digit'
    year:   'numeric'
.split('/').reverse().join '-'

console.log date.toLocaleDateString 'en-US',
    weekday: 'long'
    month:   'long'
    day:  'numeric'
    year: 'numeric'
