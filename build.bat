@echo off
REM Build script for Dungeon (Zork) Game
REM Unified script for MSVC and MinGW compilation
REM Supports Windows and UNIVAC cross-compilation

echo.
echo ========================================
echo   DUNGEON (ZORK) - Unified Build Script
echo ========================================
echo.

set COMPILER=
set UNIVAC_BUILD=

REM ============================================================================
REM STEP 1: SELECT PLATFORM
REM ============================================================================
set PLATFORM=
echo Please select target platform:
echo   Press ENTER or 1 for Windows
echo   Press 2 for UNIVAC (cross-compile)
echo.
set /p PLATFORM="Enter your choice (default: Windows): "

if "%PLATFORM%"=="" set PLATFORM=1
if "%PLATFORM%"=="1" goto SELECT_COMPILER
if "%PLATFORM%"=="2" (
    set COMPILER=1
    set UNIVAC_BUILD=1
    goto BUILD_START
)
echo Invalid choice. Defaulting to Windows.
set PLATFORM=1

REM ============================================================================
REM STEP 2: SELECT COMPILER (Windows only)
REM ============================================================================
:SELECT_COMPILER
echo.
echo Please select your compiler:
echo   Press ENTER or 1 for MinGW
echo   Press 2 for MSVC
echo.
set /p COMPILER="Enter your choice (default: MinGW): "

if "%COMPILER%"=="" set COMPILER=1
if "%COMPILER%"=="1" goto BUILD_START
if "%COMPILER%"=="2" goto BUILD_START
echo Invalid choice. Defaulting to MinGW.
set COMPILER=1

REM ============================================================================
REM BUILD START
REM ============================================================================
:BUILD_START
echo.
echo Building Dungeon (Zork) Game...
echo.

REM Jump to the selected compiler build
if defined UNIVAC_BUILD goto UNIVAC_BUILD
if "%COMPILER%"=="1" goto MINGW_BUILD
if "%COMPILER%"=="2" goto MSVC_BUILD
goto MINGW_BUILD

REM ============================================================================
REM UNIVAC BUILD (Cross-compile with -DUNIVAC flag)
REM ============================================================================
:UNIVAC_BUILD
echo.
REM Check if gcc is available
where gcc >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: GCC not found in PATH
    echo Please install MinGW-w64 or your cross-compiler toolchain
    pause
    exit /b 1
)

echo Compiler: GCC with UNIVAC flag
gcc --version | findstr "gcc"
echo.

REM Clean previous build artifacts
echo Cleaning previous build artifacts...
if exist zork_univac.exe del /Q zork_univac.exe
if exist *.o del /Q *.o
echo.

echo Building for UNIVAC platform...
echo Compiler: GCC
echo Platform Flags: -DUNIVAC -DALLOW_GDT -DMORE_NONE
echo.

REM Source files for Zork/Dungeon
set SOURCES=dmain.c dgame.c dinit.c dso1.c dso2.c dso3.c dso4.c dso5.c dso6.c dso7.c
set SOURCES=%SOURCES% actors.c ballop.c clockr.c demons.c dsub.c dverb1.c dverb2.c gdt.c
set SOURCES=%SOURCES% lightp.c local.c nobjs.c np.c np1.c np2.c np3.c nrooms.c
set SOURCES=%SOURCES% objcts.c rooms.c sobjs.c supp.c sverbs.c verbs.c villns.c

echo Compiling all source files...
gcc -c -DUNIVAC -DALLOW_GDT -DMORE_NONE -O2 -Wall %SOURCES%

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Compilation failed
    pause
    exit /b 1
)

echo Linking...
set OBJECTS=dmain.o dgame.o dinit.o dso1.o dso2.o dso3.o dso4.o dso5.o dso6.o dso7.o
set OBJECTS=%OBJECTS% actors.o ballop.o clockr.o demons.o dsub.o dverb1.o dverb2.o gdt.o
set OBJECTS=%OBJECTS% lightp.o local.o nobjs.o np.o np1.o np2.o np3.o nrooms.o
set OBJECTS=%OBJECTS% objcts.o rooms.o sobjs.o supp.o sverbs.o verbs.o villns.o
gcc -o zork_univac.exe %OBJECTS%

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo   BUILD SUCCESSFUL - UNIVAC
    echo ========================================
    echo.
    echo Output: zork_univac.exe

    REM Display file size
    for %%A in (zork_univac.exe) do (
        echo File size: %%~zA bytes
    )
    echo.
    echo Platform: UNIVAC ^(cross-compiled with -DUNIVAC^)
    echo.
    echo NOTE: This executable is built for UNIVAC compatibility:
    echo   - No Windows dependencies ^(windows.h^)
    echo   - Uses strncpy for safe string operations
    echo   - Compatible with vintage mainframe systems
    echo   - Simplified terminal handling (no termcap)
    echo.
    echo To run: zork_univac.exe
    echo.
    goto :EOF
) else (
    echo.
    echo ========================================
    echo   BUILD FAILED
    echo ========================================
    echo.
    echo Check the error messages above.
    pause
    exit /b 1
)

exit /b 0

REM ============================================================================
REM MINGW BUILD
REM ============================================================================
:MINGW_BUILD
echo.
REM Check if gcc is available
where gcc >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: MinGW GCC not found in PATH
    echo Please install MinGW-w64 and add it to your PATH
    echo Download from: https://www.mingw-w64.org/
    pause
    exit /b 1
)

echo Compiler: MinGW GCC
gcc --version | findstr "gcc"
echo.

REM Clean previous build artifacts
echo Cleaning previous build artifacts...
if exist zork_mingw.exe del /Q zork_mingw.exe
if exist *.obj del /Q *.obj
if exist *.o del /Q *.o
echo.

REM ============================================================================
REM OPTIMIZATION FLAGS FOR ZORK/DUNGEON
REM ============================================================================
REM -O2              : Good optimization level (O3 can cause issues with old code)
REM -Wall            : Enable all warnings
REM ============================================================================

set OPTIMIZE_FLAGS=-O2
set WARNING_FLAGS=-Wall -Wno-unused-parameter
set GAME_FLAGS=-DALLOW_GDT -DMORE_NONE
set LINKER_FLAGS=-s -static

echo Building Dungeon (Zork) with optimizations...
echo Compiler: MinGW GCC
echo Flags: %OPTIMIZE_FLAGS% %GAME_FLAGS%
echo.

REM Source files for Zork/Dungeon
set SOURCES=dmain.c dgame.c dinit.c dso1.c dso2.c dso3.c dso4.c dso5.c dso6.c dso7.c
set SOURCES=%SOURCES% actors.c ballop.c clockr.c demons.c dsub.c dverb1.c dverb2.c gdt.c
set SOURCES=%SOURCES% lightp.c local.c nobjs.c np.c np1.c np2.c np3.c nrooms.c
set SOURCES=%SOURCES% objcts.c rooms.c sobjs.c supp.c sverbs.c verbs.c villns.c

echo Compiling all source files...
gcc -c %WARNING_FLAGS% %OPTIMIZE_FLAGS% %GAME_FLAGS% %SOURCES%

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Compilation failed
    pause
    exit /b 1
)

echo Linking...
set OBJECTS=dmain.o dgame.o dinit.o dso1.o dso2.o dso3.o dso4.o dso5.o dso6.o dso7.o
set OBJECTS=%OBJECTS% actors.o ballop.o clockr.o demons.o dsub.o dverb1.o dverb2.o gdt.o
set OBJECTS=%OBJECTS% lightp.o local.o nobjs.o np.o np1.o np2.o np3.o nrooms.o
set OBJECTS=%OBJECTS% objcts.o rooms.o sobjs.o supp.o sverbs.o verbs.o villns.o
gcc %LINKER_FLAGS% -o zork_mingw.exe %OBJECTS%

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo   BUILD SUCCESSFUL
    echo ========================================
    echo.
    echo Output: zork_mingw.exe

    REM Display file size
    for %%A in (zork_mingw.exe) do (
        echo File size: %%~zA bytes
    )
    echo.
    echo Optimization level: -O2
    echo.
    echo To run the game: zork_mingw.exe
    echo.
) else (
    echo.
    echo ========================================
    echo   BUILD FAILED
    echo ========================================
    echo.
    echo Check the error messages above.
    pause
    exit /b 1
)

exit /b 0

REM ============================================================================
REM MSVC BUILD
REM ============================================================================
:MSVC_BUILD
echo.
REM Set up Visual Studio Developer Command Prompt environment
REM Try common Visual Studio 2022 installation paths
if exist "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat" (
    call "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat" -no_logo
) else if exist "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\Tools\VsDevCmd.bat" (
    call "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\Tools\VsDevCmd.bat" -no_logo
) else if exist "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\VsDevCmd.bat" (
    call "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\VsDevCmd.bat" -no_logo
) else (
    echo Error: Could not find Visual Studio 2022 installation.
    echo Please ensure Visual Studio 2022 is installed.
    pause
    exit /b 1
)

echo.
echo Compiler: MSVC (Visual Studio 2022)
echo Compiling Dungeon (Zork) with MSVC...
echo.

REM Source files for Zork/Dungeon
set SOURCES=dmain.c dgame.c dinit.c dso1.c dso2.c dso3.c dso4.c dso5.c dso6.c dso7.c
set SOURCES=%SOURCES% actors.c ballop.c clockr.c demons.c dsub.c dverb1.c dverb2.c gdt.c
set SOURCES=%SOURCES% lightp.c local.c nobjs.c np.c np1.c np2.c np3.c nrooms.c
set SOURCES=%SOURCES% objcts.c rooms.c sobjs.c supp.c sverbs.c verbs.c villns.c

REM Compile all source files
cl /W3 /O2 /DALLOW_GDT /DMORE_NONE /Fe:zork.exe %SOURCES%

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo   BUILD SUCCESSFUL
    echo ========================================
    echo.
    echo Output: zork.exe
    echo.
    echo To run the game: zork.exe
    echo.
) else (
    echo.
    echo ========================================
    echo   BUILD FAILED
    echo ========================================
    echo.
    pause
    exit /b 1
)

exit /b 0
