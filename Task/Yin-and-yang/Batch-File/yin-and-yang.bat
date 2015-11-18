@echo off

	%== Set the dimension of the SVG 'image' that will be created ==%
set pic_width=30
set pic_height=30

	%== Redirect the SVG stdout to 'YINYANG.SVG' in the same directory ==%

echo.^<?xml version='1.0' encoding='UTF-8' standalone='no'?^>>YINYANG.SVG
echo.^<!DOCTYPE svg PUBLIC '-//W3C//DTD SVG 1.1//EN'>>YINYANG.SVG
echo.	'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd'^>>>YINYANG.SVG
echo.^<svg xmlns='http://www.w3.org/2000/svg' version='1.1'>>YINYANG.SVG
echo.	xmlns:xlink='http://www.w3.org/1999/xlink'>>YINYANG.SVG
echo.		width='%pic_width%' height='%pic_height%'^>>>YINYANG.SVG
echo.	^<defs^>^<g id='y'^>>>YINYANG.SVG
echo.		^<circle cx='0' cy='0' r='200' stroke='black'>>YINYANG.SVG
echo.			fill='white' stroke-width='1'/^>>>YINYANG.SVG
echo.		^<path d='M0 -200 A 200 200 0 0 0 0 200>>YINYANG.SVG
echo.			100 100 0 0 0 0 0 100 100 0 0 1 0 -200>>YINYANG.SVG
echo.			z' fill='black'/^>>>YINYANG.SVG
echo.		^<circle cx='0' cy='100' r='33' fill='white'/^>>>YINYANG.SVG
echo.		^<circle cx='0' cy='-100' r='33' fill='black'/^>>>YINYANG.SVG
echo.	^</g^>^</defs^>>>YINYANG.SVG

	%== Create the yin-yang symbol ==%
call :draw_yinyang 20 0.05
call :draw_yinyang 8 0.02

echo.^</svg^>>>YINYANG.SVG
exit /b 0

:draw_yinyang
echo.^<use xlink:href='#y' transform='translate(%1,%1) scale(%2)'/^>>>YINYANG.SVG
goto :EOF
