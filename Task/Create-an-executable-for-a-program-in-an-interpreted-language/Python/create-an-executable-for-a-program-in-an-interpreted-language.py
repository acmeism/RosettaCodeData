#include <Python.h>

int main() {
    Py_Initialize();

    const char *code =
        "x = 10\n"
        "y = 20\n"
        "z = x + y\n"
        "if z == 30:\n"
        "\tprint(z, 'is thirty')\n"
        "print(f'Total: {z}')\n";

    PyObject *globals = PyDict_New();
    PyObject *locals = PyDict_New();

    PyObject *res = PyRun_String(code, Py_file_input, globals, locals);
    if (!res) PyErr_Print();

    Py_DECREF(globals);
    Py_DECREF(locals);

    Py_Finalize();
    return 0;
}
