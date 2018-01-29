:: Premake5 Invoker util
:: Author(s):       iFarbod <ifarbod@outlook.com>
::
:: Copyright (c) 2013-2018 The CTNorth Authors
::
:: Distributed under the MIT license (See accompanying file LICENSE or copy at
:: https://opensource.org/licenses/MIT)

@echo off

cd ..\src

if "%1" == "clean" (
    :: Invoke premake5's clean action
    echo Performing clean action...
    premake5 clean
) else (
    :: Invoke premake5 with specified args and VS2017 action
    premake5 %* vs2017
)

:: Pause for 5 seconds and auto-close the command window
:end
timeout /t 5 /nobreak
