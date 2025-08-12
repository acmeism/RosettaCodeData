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
import json ;; just in case it's not yet imported
probe reb: decode 'json json-str
probe str: encode 'json reb ;; outputs without any indentation
;; Validate that re-encoded JSON is same
probe equal? reb decode 'json str
