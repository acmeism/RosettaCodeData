var caesar = (text, shift) => text
  .toUpperCase()
  .replace(/[^A-Z]/g, '')
  .replace(/[A-Z]/g, a =>
    String.fromCharCode(65 + (a.charCodeAt(0) - 65 + shift) % 26));
