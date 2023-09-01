*> INVOKE statements.
INVOKE my-class "some-method"          *> Factory object
    USING BY REFERENCE some-parameter
    RETURNING foo
INVOKE my-instance "another-method"    *> Instance object
    USING BY REFERENCE some-parameter
    RETURNING foo

*> Inline method invocation.
MOVE my-class::"some-method"(some-parameter) TO foo       *> Factory object
MOVE my-instance::"another-method"(some-parameter) TO foo *> Instance object
