@echo off
cd /d D:\daily-commit

:: File paths
set notesfile=D:\ml_notes.txt
set outfile=dl_notes.txt
set offsetfile=offset.txt

:: If offset file doesn’t exist, start from line 1
if not exist %offsetfile% echo 1 > %offsetfile%

:: Read current offset (line number to start from)
set /p start=<%offsetfile%

:: Calculate end line
set /a end=%start%+4

:: Clear output file before writing
> %outfile% (

    setlocal enabledelayedexpansion
    set lineNo=0

    for /f "usebackq delims=" %%A in ("%notesfile%") do (
        set /a lineNo+=1
        if !lineNo! geq %start% if !lineNo! leq %end% echo %%A
    )
    endlocal
)

:: Update offset for next run
set /a next=%end%+1
echo %next% > %offsetfile%

:: Stage all files
git add -A

:: Commit with timestamp
set commitmsg=Auto commit - %date% %time%
git commit -m "%commitmsg%" 2>nul

:: Push to GitHub
git push origin main
