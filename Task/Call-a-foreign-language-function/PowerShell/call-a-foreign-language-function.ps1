<# :
@echo off
setlocal enableextensions
pushd %~dp0
start "Rotating Donut" conhost powershell -NoProfile -NoLogo "iex (${%~f0} | out-string)"
goto :eof
#>
# https://www.dostips.com/forum/viewtopic.php?t=10156
Add-Type '
using System;
using System.Runtime.InteropServices;
[StructLayout(LayoutKind.Sequential,CharSet=CharSet.Unicode)] public struct FontInfo{
public int objSize;
public int nFont;
public short fontSizeX;
public short fontSizeY;
public int fontFamily;
public int fontWeight;
[MarshalAs(UnmanagedType.ByValTStr,SizeConst=32)] public string faceName;}
public class WApi{
[DllImport("kernel32.dll")] public static extern IntPtr CreateFile(string name,int acc,int share,IntPtr sec,int how,int flags,IntPtr tmplt);
[DllImport("kernel32.dll")] public static extern void GetCurrentConsoleFontEx(IntPtr hOut,int maxWnd,ref FontInfo info);
[DllImport("kernel32.dll")] public static extern void SetCurrentConsoleFontEx(IntPtr hOut,int maxWnd,ref FontInfo info);
[DllImport("kernel32.dll")] public static extern void CloseHandle(IntPtr handle);}';
$hOut = [WApi]::CreateFile('CONOUT$',-1073741824,2,[IntPtr]::Zero,3,0,[IntPtr]::Zero);
$fInf = New-Object FontInfo;
$fInf.objSize = 84;
$fInf.nFont=12; $fInf.fontSizeX=16; $fInf.fontSizeY=12; $fInf.fontFamily=48; $fInf.fontWeight=400; $fInf.faceName='Terminal'
[WApi]::SetCurrentConsoleFontEx($hOut,0,[ref]$fInf);
[WApi]::CloseHandle($hOut);
$env:isAutoran=1
cmd /c _donut.bat
# download _donut.bat and save it in the same directory as the script's : https://www.dostips.com/forum/viewtopic.php?f=3&t=11919&p=71274
