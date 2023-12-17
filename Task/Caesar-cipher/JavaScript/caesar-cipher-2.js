var caesar = (text, shift) => text
  .toUpperCase()
  .replace(/[^A-Z]/g, '')
  .replace(/./g, a =>
    String.fromCharCode(((a.charCodeAt(0) - 65 + shift) % 26 + 26) % 26 + 65));
