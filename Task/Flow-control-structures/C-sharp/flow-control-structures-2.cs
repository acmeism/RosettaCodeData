try {
    if (someCondition) {
        throw new Exception();
    }
} catch (Exception ex) {
    LogException(ex);
    throw;
} finally {
    cleanUp();
}
