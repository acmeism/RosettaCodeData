try {
    new BinaryNodeBuilder().'1' {
        a {}
        b {}
        c {}
    }
    println 'not limited to binary tree\r\n'
} catch (org.codehaus.groovy.transform.powerassert.PowerAssertionError e) {
    println 'limited to binary tree\r\n'
}
