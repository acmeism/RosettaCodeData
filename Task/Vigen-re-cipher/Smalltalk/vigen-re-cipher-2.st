plain := 'Beware the Jabberwock, my son! The jaws that bite, the claws that catch!'.
cypher := 'VIGENERECIPHER'.
crypted := encrypt value:plain value:cypher.
plain2 := decrypt value:crypted value:cypher.

crypted -> 'WMCEEIKLGRPIFVMEUGXQPWQVIOIAVEYXUEKFKBTALVXTGAFXYEVKPAGY'
plain2  -> 'BEWARETHEJABBERWOCKMYSONTHEJAWSTHATBITETHECLAWSTHATCATCH'
