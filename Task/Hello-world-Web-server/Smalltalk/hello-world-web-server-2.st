(ZnServer startDefaultOn: 1701)
   onRequestRespond: [ :request |
      ZnResponse ok: (ZnEntity text: 'Hello World!') ].
