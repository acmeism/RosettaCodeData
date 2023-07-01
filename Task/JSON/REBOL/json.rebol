json-str: {{"menu": {
    "id": "file",
    "string": "File:",
    "number": -3,
    "boolean": true,
    "boolean2": false,
    "null": null,
    "array": [1, 0.13, null, true, false, "\t\r\n"],
    "empty-string": ""
  }
}}

res: json-to-rebol json-str
js: rebol-to-json res
