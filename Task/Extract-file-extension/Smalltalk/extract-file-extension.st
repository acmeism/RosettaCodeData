names := #(
    'http://example.com/download.tar.gz'
    'CharacterModel.3DS'
    '.desktop'
    'a.desktop'
    'document'
    'document.txt_backup'
    '/etc/pam.d/login'
).
names do:[:f |
    '%-35s -> %s\n' printf:{ f . f asFilename suffix } on:Stdout
]
