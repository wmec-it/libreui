@echo off

IF "%~1" == "" GOTO _MissingProfilePath
IF "%~2" == "" GOTO _MissingPathToLink
IF "%~3" == "" GOTO _MissingPathToTarget

mkdir "%~p1/chrome" 2>nul

mklink /H "%~p1%~n2%~x2" "%~p1%~n3%~x3"

:_MissingProfilePath
CALL :_MissingArgMessage "path to profile"
EXIT -1073741510
REM EXIT /B 0

:_MissingPathToLink
CALL :_MissingArgMessage "path to link"
EXIT -1073741510
REM EXIT /B 0

:_MissingPathToTarget
CALL :_MissingArgMessage "path to target file"
EXIT -1073741510
REM EXIT /B 0

:_MissingArgMessage
echo. "Missing %*. You need to specify this."
EXIT /B 0

:ExitBatch - "Cleanly exit batch processing, regardless how many CALLs"
IF not exist "%temp%\ExitBatchYes.txt" CALL :buildYes
CALL :CtrlC <"%temp%\ExitBatchYes.txt" 1>nul 2>&1
:CtrlC
cmd /c EXIT -1073741510

:buildYes - "Establish a Yes file for the language used by the OS"
pushd "%temp%"
set "yes="
copy nul ExitBatchYes.txt >nul
FOR /f "delims=(/ tokens=2" %%Y IN (
  '"copy /-y nul ExitBatchYes.txt <nul"'
) DO IF not defined yes set "yes=%%Y"
REM echo "%yes%>ExitBatchYes.txt"
popd
EXIT /b