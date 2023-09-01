       IDENTIFICATION DIVISION.
       CLASS-ID. Animal.
           *> ...
       END CLASS Animal.

       IDENTIFICATION DIVISION.
       CLASS-ID. Dog
           INHERITS FROM Animal.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY.
           CLASS Animal.

           *> ...
       END CLASS Dog.

       IDENTIFICATION DIVISION.
       CLASS-ID. Cat
           INHERITS FROM Animal.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY.
           CLASS Animal.

           *> ...
       END CLASS Cat.

       IDENTIFICATION DIVISION.
       CLASS-ID. Lab
           INHERITS FROM Dog.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY.
           CLASS Dog.

           *> ...
       END CLASS Lab.

       IDENTIFICATION DIVISION.
       CLASS-ID. Collie
           INHERITS FROM Dog.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY.
           CLASS Dog.

           *> ...
       END CLASS Collie.
