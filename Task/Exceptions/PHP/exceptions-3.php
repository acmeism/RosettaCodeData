try {
    throwsException();
} catch (Exception $e) {
    echo 'Caught exception: ' . $e->getMessage();
}
