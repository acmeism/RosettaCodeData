       IDENTIFICATION DIVISION.
       CLASS-ID. Camera.
           *> ...
       END CLASS Camera.

       IDENTIFICATION DIVISION.
       CLASS-ID. Mobile-Phone.
           *> ...
       END CLASS Mobile-Phone.

       IDENTIFICATION DIVISION.
       CLASS-ID. Camera-Phone
           INHERITS FROM Camera, Mobile-Phone.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY.
           CLASS Camera
           CLASS Mobile-Phone.

           *> ...
       END CLASS Camera-Phone.
