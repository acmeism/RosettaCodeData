// MFC
CString s = "12345";
int i = _ttoi(s) + 1;
int i = _tcstoul(s, NULL, 10) + 1;
s.Format("%d", i);
