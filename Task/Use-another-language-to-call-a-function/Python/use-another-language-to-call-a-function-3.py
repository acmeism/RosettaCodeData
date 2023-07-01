#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<Python.h>

int Query(char*Data,unsigned*Length) {
  char *module = "rc_embed", *function = "query";
  PyObject *pName, *pModule, *pFunc, *pResult, *pArgs, *pLength;
  long result = 0;
  if (!Py_IsInitialized())
    Py_Initialize();
  pName = PyUnicode_FromString(module);
  pModule = PyImport_Import(pName);
  Py_DECREF(pName);
  if (NULL == pModule) {
    PyErr_Print();
    fprintf(stderr,"Failed to load \"%s\"\n",module);
    return 0;
  }
  pFunc = PyObject_GetAttrString(pModule,function);
  if ((NULL == pFunc) || (!PyCallable_Check(pFunc))) {
    if (PyErr_Occurred())
      PyErr_Print();
    fprintf(stderr,"Cannot find function \"%s\"\n",function);
    if (NULL != pFunc)
      Py_DECREF(pFunc);
    Py_DECREF(pModule);
    return 0;
  }	
  pArgs = PyTuple_New(1);
  pLength = PyLong_FromUnsignedLong((unsigned long)(*Length));
  if (NULL == pLength) {
    Py_DECREF(pArgs);
    Py_DECREF(pFunc);
    Py_DECREF(pModule);
    return 0;
  }
  PyTuple_SetItem(pArgs,0,pLength);
  pResult = PyObject_CallObject(pFunc, pArgs);
  if (NULL == pResult)
    result = 0;
  else if (!PyBytes_Check(pResult)) {
    result = 0;
    Py_DECREF(pResult);
  } else {
    if (! PyBytes_Size(pResult))
      result = 0;
    else {
      *Length = (unsigned)PyBytes_Size(pResult);
      strncpy(Data,PyBytes_AsString(pResult),*Length);
      Py_DECREF(pResult);
      result = 1;
    }
  }
  Py_DECREF(pArgs);
  Py_DECREF(pFunc);
  Py_DECREF(pModule);
  Py_Finalize();
  return result;
}
