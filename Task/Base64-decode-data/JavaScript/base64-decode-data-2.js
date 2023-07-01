// define base64 data; in this case the data is the string: "Hello, world!"
const base64 = Buffer.from('SGVsbG8sIHdvcmxkIQ==', 'base64');
// <Buffer>.toString() is a built-in method.
console.log(base64.toString());
