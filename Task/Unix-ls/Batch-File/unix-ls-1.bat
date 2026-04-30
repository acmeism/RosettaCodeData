@echo off
setlocal
pushd %1
for %%a in (*) do @echo:%%a
