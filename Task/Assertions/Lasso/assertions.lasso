local(a) = 8
fail_if(
    #a != 42,
    error_code_runtimeAssertion,
    error_msg_runtimeAssertion + ": #a is not 42"
)
