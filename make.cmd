@echo off
setlocal
rem ============================================================================
rem ============================== INFO ========================================
rem This script download projects, dependencies, prepare environment and build 
rem the project.
rem The `tools` directory contains 7z.exe, wget.exe
rem ============================================================================
rem ============================== VALIDATION ==================================
rem Check if the `tools` directory exists.
if not exist tools (
    echo The `tools` directory does not exist.
    echo Please check the integrity of the project.
    exit /b 1
)
rem Check if the `7z` command exists.
if not exist tools\7z.exe (
    echo The `7z` command does not exist.
    echo Please check the integrity of the project.
    exit /b 1
)
rem Check if the `wget` command exists.
if not exist tools\wget.exe (
    echo The `wget` command does not exist.
    echo Please check the integrity of the project.
    exit /b 1
)
rem ============================================================================
rem ============================== ENVIRONMENT =================================
rem Used php version
set PHP_VERSION=8.1.27
rem Used gcc version
set GCC_VERSION=13.2.0
set PATH=%PATH%;%CD%\tools
set ARCH=7z.exe
set WGET=wget.exe
set ROOT_DIR=%CD%
set BUILD_DIR=%ROOT_DIR%\build
set PHP_DIR=tools\php
set TMP_DIR=%ROOT_DIR%\tmp
set PLATFORM_DIR=%BUILD_DIR%\platform
set SANDBOX_DIR=%BUILD_DIR%\sandbox
set JUDGE_DIR=%BUILD_DIR%\judge
rem Repository URLs
set PLATFORM_REPO=https://github.com/devrdn/olymp-platform/archive/refs/heads/main.zip
set SANDBOX_REPO=https://github.com/Kutabarik/olymp-sandbox/archive/refs/heads/main.zip
set JUDGE_REPO=https://github.com/mcroitor/olymp-judge/archive/refs/heads/main.zip
rem php and gcc download urls
set PHP_URL=https://windows.php.net/downloads/releases/php-%PHP_VERSION%-nts-Win32-vs16-x64.zip
set GCC_URL=https://github.com/niXman/mingw-builds-binaries/releases/download/%GCC_VERSION%-rt_v11-rev0/i686-%GCC_VERSION%-release-posix-dwarf-msvcrt-rt_v11-rev0.7z
rem ============================================================================
rem ============================== DOWNLOAD ====================================
rem Check if php.exe exists in system. If not exists, download it and unpack to the
rem `tools\php` directory.
if not exist %BUILD_DIR% (
    mkdir %BUILD_DIR%
)
if not exist %TMP_DIR% (
    mkdir %TMP_DIR%
)
(php.exe -v >nul 2>&1) && (
    echo PHP is installed.
) || (
    echo PHP is not installed.
    if not exist %PHP_DIR% (
        mkdir %PHP_DIR%
    )
    if not exist %TMP_DIR%\php.zip (
        echo Downloading PHP...
        %WGET% -O %TMP_DIR%\php.zip %PHP_URL%
    )
    echo Unpacking PHP...
    %ARCH% x -o%PHP_DIR% %TMP_DIR%\php.zip
    echo Done.
)
rem Check if gcc.exe exists in system. If not exists, download it and unpack to the
rem `tools\gcc` directory.
(gcc.exe -v >nul 2>&1) && (
    echo GCC is installed.
) || (
    echo GCC is not installed.
    if not exist %TMP_DIR% (
        mkdir %TMP_DIR%
    )
    if not exist %TMP_DIR%\gcc.7z (
        echo Downloading GCC...
        %WGET% -O %TMP_DIR%\gcc.7z %GCC_URL%
    )
    echo Unpacking GCC...
    %ARCH% x -o%TMP_DIR% %TMP_DIR%\gcc.7z
    echo Done.
)
rem Download and unpack the platform project if not exists.
if not exist %PLATFORM_DIR% (
    if not exist %TMP_DIR%\platform.zip (
        echo Downloading platform...
        echo %WGET% -O %TMP_DIR%\platform.zip %PLATFORM_REPO%
        %WGET% -O %TMP_DIR%\platform.zip %PLATFORM_REPO%
        echo Done.
    )
    echo Unpacking platform...
    %ARCH% x -o%BUILD_DIR% %TMP_DIR%\platform.zip
    mv %BUILD_DIR%\olymp-platform-main %PLATFORM_DIR%
    echo Done.
)
rem Download and unpack the sandbox project.
if not exist %SANDBOX_DIR% (
    if not exist %TMP_DIR%\sandbox.zip (
        echo Downloading sandbox...
        %WGET% -O %TMP_DIR%\sandbox.zip %SANDBOX_REPO%
        echo Done.
    )
    echo Unpacking sandbox...
    %ARCH% x -o%BUILD_DIR% %TMP_DIR%\sandbox.zip
    mv %BUILD_DIR%\olymp-sandbox-main %SANDBOX_DIR%
    echo Done.
)
rem Download and unpack the judge project.
if not exist %JUDGE_DIR% (
    if not exist %TMP_DIR%\judge.zip (
        echo Downloading judge...
        %WGET% -O %TMP_DIR%\judge.zip %JUDGE_REPO%
        echo Done.
    )
    echo Unpacking judge...
    %ARCH% x -o%BUILD_DIR% %TMP_DIR%\judge.zip
    mv %BUILD_DIR%\olymp-judge-main %JUDGE_DIR%
    echo Done.
)
rem ============================================================================
rem ============================== BUILD =======================================
rem Build the project.
cd %BUILD_DIR%\platform
echo Building platform...
rem TODO: Add build commands here.
echo Done.
cd %BUILD_DIR%\sandbox
echo Building sandbox...
mkdir build
cd build
cmake ..
cmake --build .
echo Done.
cd %BUILD_DIR%\judge
echo Building judge...
rem TODO: Add build commands here.
echo Done.
rem ============================================================================
rem ============================== CLEAN =======================================
rem Clean the environment.
echo Cleaning...
rmdir /s /q %TMP_DIR%
echo Done.
rem ============================================================================
rem ============================== END =========================================
endlocal
