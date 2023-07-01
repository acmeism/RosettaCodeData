class friendly_class definition deferred.

class my_class definition friends friendly_class .

  public section.
    methods constructor.

  private section.
    data secret type char30.

endclass.

class my_class implementation .

  method constructor.
    secret = 'a password'. " Instantiate secret.
  endmethod.

endclass.

class friendly_class definition create public .

  public section.
    methods return_secret
      returning value(r_secret) type char30.

endclass.

class friendly_class implementation.

  method return_secret.

    data lr_my_class type ref to my_class.

    create object lr_my_class. " Instantiate my_class

    write lr_my_class->secret. " Here's the privacy violation.

  endmethod.

endclass.
