#!/usr/bin/env python
# -*- coding: utf-8 -*-
import win32com.client
from win32com.server.util import wrap, unwrap
from win32com.server.dispatcher import DefaultDebugDispatcher
from ctypes import *
import commands
import pythoncom
import winerror
from win32com.server.exception import Exception

clsid = "{55C2F76F-5136-4614-A397-12214CC011E5}"
iid = pythoncom.MakeIID(clsid)
appid = "python.server"

class VeryPermissive:
    def __init__(self):
        self.data = []
        self.handle = 0
        self.dobjects = {}
    def __del__(self):
        pythoncom.RevokeActiveObject(self.handle)
    def _dynamic_(self, name, lcid, wFlags, args):
        if wFlags & pythoncom.DISPATCH_METHOD:
            return getattr(self,name)(*args)
        if wFlags & pythoncom.DISPATCH_PROPERTYGET:
            try:
                # to avoid problems with byref param handling, tuple results are converted to lists.
                ret = self.__dict__[name]
                if type(ret)==type(()):
                    ret = list(ret)
                return ret
            except KeyError: # Probably a method request.
                raise Exception(scode=winerror.DISP_E_MEMBERNOTFOUND)
        if wFlags & (pythoncom.DISPATCH_PROPERTYPUT | pythoncom.DISPATCH_PROPERTYPUTREF):
            setattr(self, name, args[0])
            return
        raise Exception(scode=winerror.E_INVALIDARG, desc="invalid wFlags")
    def write(self, x):
        print x
        return 0
import win32com.server.util, win32com.server.policy
child = VeryPermissive()
ob = win32com.server.util.wrap(child, usePolicy=win32com.server.policy.DynamicPolicy)
try:
    handle = pythoncom.RegisterActiveObject(ob, iid, 0)
except pythoncom.com_error, details:
    print "Warning - could not register the object in the ROT:", details
    handle = None
child.handle = handle

ahk = win32com.client.Dispatch("ahkdemo.ahk")
ahk.aRegisterIDs(clsid, appid)
# autohotkey.exe ahkside.ahk
# python /c/Python26/Scripts/ipython.py -wthread -i pythonside.py
# must use -wthread otherwise calling com client hangs
