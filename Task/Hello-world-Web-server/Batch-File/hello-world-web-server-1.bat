@echo off
setlocal enableextensions
::net session would not work if the Server service is not started
reg query HKEY_USERS\S-1-5-19\Environment /v TEMP >nul 2>nul || (
  >&2 echo Please run this script in an elevated prompt.
  exit /b 1
)
dism /online /enable-feature /featurename:IIS-WebServerRole /all
:: https://learn.microsoft.com/en-us/iis/configuration/system.applicationhost/sites/site/bindings/
%windir%\system32\inetsrv\appcmd set site /site.name:"Default Web Site" /+bindings.[protocol='http',bindingInformation='*:8080:']
pushd %SystemDrive%\inetpub\wwwroot
:: ren iisstart.htm iisstart.htm.old %= rename the original iisstart.htm to avoid overwriting it =%
echo ^<html^>^<body^>Goodbye, World!^</body^>^</html^> >iisstart.htm
:: there's no need to popd as setlocal is enabled
