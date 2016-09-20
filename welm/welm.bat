@echo off

setlocal enabledelayedexpansion enableextensions

if exist "%WINDIR%\System32\wevtutil.exe" (

    if exist logs (
        rmdir /S /Q logs
    )

    mkdir logs
    pushd logs

    wevtutil el > logs.txt

    for /f "tokens=*" %%A in ('wevtutil el') do (
        set XML_FILENAME=%%A
        set XML_FILENAME=!XML_FILENAME:/=--!
        wevtutil gl "%%A" /f:xml > "!XML_FILENAME!.xml"
    )

    popd

    if exist publishers (
        rmdir /S /Q publishers
    )

    mkdir publishers
    pushd publishers

    wevtutil ep > publishers.txt

    for /f "tokens=*" %%A in ('wevtutil ep') do (
        set XML_FILENAME=%%A
        set XML_FILENAME=!XML_FILENAME:/=--!
        wevtutil gp "%%A" /ge /gm:true /f:xml > "!XML_FILENAME!.xml"
    )

    popd
)


welm.exe -e -f all
welm.exe -p -f all
welm.exe -l -f all

endlocal