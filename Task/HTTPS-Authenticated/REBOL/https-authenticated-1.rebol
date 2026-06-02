;; Encode the string "admin:admin" into Base64 format
auth: enbase "admin:admin" 64
;; Perform an HTTP GET request to a test endpoint requiring Basic Authentication
print write https://httpbin.org/basic-auth/admin/admin compose/deep [
    GET [
        ;; Include HTTP header "Authorization: Basic <base64 credentials>"
        Authorization: (join "Basic " auth)
    ]
]
