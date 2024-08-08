@echo off & setlocal enabledelayedexpansion

:clear

for /l %%n in (1,1,100) do set tail%%n=0
set lastchoice=1
set snakeheadlast=0
set up=0
set right=1
set apples=0

call :apples
call :check

:reset

if %apples%==99 goto win
call :apples
call :applecheck


:home

set lastchoice=%ERRORLEVEL%

if %apples% GEQ 1 call :tailcheck

cls

set next2=10
set next=1

for /l %%c in (1,1,10) do (
	set "line%%c="
)

echo [%retrycount%]
echo [Apples:%apples%]
for /l %%a in (1,1,10) do (
	for /l %%b in (!next!,1,!next2!) do (
		set "line%%a=!line%%a![!s%%b!]"
	)
	set /a next+=10
	set /a next2+=10
)

for /l %%a in (1,1,10) do echo !line%%a! 

choice /t 1 /c sawdp /m "WASD to move" /n /d p
 
if %ERRORLEVEL%==5 goto default
 
if %ERRORLEVEL%==4 (
  set /a right+=1 
  goto check
)
if %ERRORLEVEL%==3 (
  set /a up-=10
  goto check
)
if %ERRORLEVEL%==2 (
  set /a right-=1
  goto check
)
if %ERRORLEVEL%==1 (
  set /a up+=10
  goto check
)

============================

:default

if %lastchoice%==4 (
  set /a right+=1 
  goto check
)
if %lastchoice%==3 (
  set /a up-=10
  goto check
)
if %lastchoice%==2 (
  set /a right-=1
  goto check
)
if %lastchoice%==1 (
  set /a up+=10
  goto check
)

===========================

:firstapplecheck

if %lastchoice%==1 if %ERRORLEVEL%==3 goto lose
if %lastchoice%==2 if %ERRORLEVEL%==4 goto lose
if %lastchoice%==3 if %ERRORLEVEL%==1 goto lose
if %lastchoice%==4 if %ERRORLEVEL%==2 goto lose

exit /b

===========================

:check

if %apples%==1 call :firstapplecheck

for /l %%c in (1,1,100) do (
	set "s%%c= "
)

if %up%==-10 goto lose
if %right%==0 goto lose

if %up%==100 goto lose
if %right%==11 goto lose

set snakeheadlast=%snakehead%

set /a snakehead=%up%+%right%

set s%snakehead%=O

goto applecheck

exit /b

============================

:apples

set /a applepos1=%random% %%50 + 1
set /a applepos2=%random% %%50 + 1

set /a appleloc=%applepos1%+%applepos2%

exit /b

============================

:applecheck

if %snakehead%==%appleloc% set /a apples+=1 & goto reset

set s%appleloc%=A

goto home

==========================

:tailcheck

set tail!snakeheadlast!=%apples%

for /l %%e in (1,1,100) do (
	if !tail%%e! GEQ 1 set "s%%e=X"
)

call :tailsub
call :snakecollisioncheck
exit /b

==========================

:tailsub

for /l %%w in (1,1,100) do (
	if !tail%%w! GEQ 1 set /a tail%%w-=1
)

exit /b

==========================

:snakecollisioncheck

if !s%appleloc%!==X set /a retrycount+=1 & goto reset

if !s%snakehead%!==X goto lose

exit /b

===================================

:lose
cls
echo You lost.
echo Youre score was [%apples%].
choice /c YN /m "Would you like to retry?"

if %errorlevel%==2 exit
if %errorlevel%==1 goto clear

=========================

:win
cls
echo You won.
echo Youre score was [%apples%].
choice /c YN /m "Would you like to retry?"

if %errorlevel%==2 exit
if %errorlevel%==1 goto clear

=========================

