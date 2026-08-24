@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
set PYTHONIOENCODING=utf-8
cd /d "%~dp0"

:: ── Пошук Python ──
set "PYTHON_CMD="
where py >nul 2>&1 && set "PYTHON_CMD=py"
if not defined PYTHON_CMD (
    where python >nul 2>&1 && set "PYTHON_CMD=python"
)
if not defined PYTHON_CMD (
    where python3 >nul 2>&1 && set "PYTHON_CMD=python3"
)
if not defined PYTHON_CMD (
    if exist "%LOCALAPPDATA%\Programs\Python\Python314\python.exe" (
        set "PYTHON_CMD=%LOCALAPPDATA%\Programs\Python\Python314\python.exe"
    ) else if exist "%LOCALAPPDATA%\Programs\Python\Python313\python.exe" (
        set "PYTHON_CMD=%LOCALAPPDATA%\Programs\Python\Python313\python.exe"
    ) else if exist "C:\Program Files\Python314\python.exe" (
        set "PYTHON_CMD=C:\Program Files\Python314\python.exe"
    ) else if exist "C:\Program Files\Python313\python.exe" (
        set "PYTHON_CMD=C:\Program Files\Python313\python.exe"
    )
)

if not defined PYTHON_CMD (
    echo ================================================================
    echo [ПОМИЛКА] Python не знайдено в системі! Встановіть Python 3.
    echo ================================================================
    pause
    exit /b 1
)

:: ── Якщо передано аргументи при запуску ──
if not "%~1"=="" (
    "!PYTHON_CMD!" "%~dp0get_htm.py" %*
    goto :eof
)

:: ── Головне Меню ──
:MENU
cls
echo ================================================================
echo        ЗАВАНТАЖУВАЧ HTM ДОКУМЕНТІВ З ZAKON.RADA.GOV.UA
echo          (Оптимізовано для швидкісного пакетного режиму)
echo ================================================================
echo.
echo  [1] Варіант 1: Прямий виклик експортного API (zakon.rada.gov.ua)
echo  [2] Варіант 2: Збирання 1:1 файлу через OpenData API (data.rada.gov.ua)
echo  [3] Завантажити Обидва варіанти (Варіант 1 + Варіант 2)
echo  [4] Пакетне завантаження зі списку файлу (.txt зі списком законів)
echo  [5] Швидкий тест основних кодексів (Конституція, КЗпП, ЦКУ, ККУ)
echo  [6] Відкрити робочу папку з файлами
echo.
echo  [0] Вихід
echo ================================================================
echo.
set "CHOICE="
set /p "CHOICE=Оберіть варіант [0-6]: "

if not defined CHOICE goto MENU
set "CLEAN_CHOICE=!CHOICE:"=!"

if "!CLEAN_CHOICE!"=="1" goto DOWNLOAD_VARIANT_1
if "!CLEAN_CHOICE!"=="2" goto DOWNLOAD_VARIANT_2
if "!CLEAN_CHOICE!"=="3" goto DOWNLOAD_BOTH_VARIANTS
if "!CLEAN_CHOICE!"=="4" goto DOWNLOAD_FILE_LIST
if "!CLEAN_CHOICE!"=="5" goto DOWNLOAD_BENCHMARK
if "!CLEAN_CHOICE!"=="6" goto OPEN_FOLDER
if "!CLEAN_CHOICE!"=="0" goto EXIT_APP

echo.
echo [!] Невірний вибір. Спробуйте ще раз.
timeout /t 2 >nul
goto MENU

:DOWNLOAD_VARIANT_1
echo.
echo ----------------------------------------------------------------
echo  [1] Варіант 1: Прямий виклик експортного API (zakon.rada.gov.ua)
echo  (Введіть номер, назву або посилання. Можна кілька через пробіл)
echo  Приклад: 322-08 4742-20 або ЦИВІЛЬНИЙ КОДЕКС УКРАЇНИ
echo ----------------------------------------------------------------
set "TARGETS="
set /p "TARGETS=Введіть номери, назву або URL: "
if not defined TARGETS goto MENU
echo.
"!PYTHON_CMD!" "%~dp0get_htm.py" !TARGETS! --mode export --skip-existing
echo.
pause
goto MENU

:DOWNLOAD_VARIANT_2
echo.
echo ----------------------------------------------------------------
echo  [2] Варіант 2: Збирання 1:1 файлу через OpenData API (data.rada.gov.ua)
echo  (Введіть номер, назву або посилання. Можна кілька через пробіл)
echo  Приклад: 322-08 4742-20 або ЦИВІЛЬНИЙ КОДЕКС УКРАЇНИ
echo ----------------------------------------------------------------
set "TARGETS="
set /p "TARGETS=Введіть номери, назву або URL: "
if not defined TARGETS goto MENU
echo.
"!PYTHON_CMD!" "%~dp0get_htm.py" !TARGETS! --mode opendata --skip-existing
echo.
pause
goto MENU

:DOWNLOAD_BOTH_VARIANTS
echo.
echo ----------------------------------------------------------------
echo  [3] Завантажити Обидва варіанти (Варіант 1 + Варіант 2)
echo  (Введіть номер документа, назву або URL для порівняння)
echo  Приклад: 322-08 або ЦИВІЛЬНИЙ КОДЕКС УКРАЇНИ
echo ----------------------------------------------------------------
set "TARGET="
set /p "TARGET=Введіть номер документа, назву або URL: "
if not defined TARGET goto MENU
echo.
"!PYTHON_CMD!" "%~dp0download_both_variants.py" !TARGET!
echo.
pause
goto MENU

:DOWNLOAD_FILE_LIST
echo.
echo ----------------------------------------------------------------
echo  [4] Пакетне завантаження зі списку файлу
echo ----------------------------------------------------------------
set "LIST_FILE="
set /p "LIST_FILE=Введіть шлях до файлу списку (або перетягніть .txt сюди): "
if not defined LIST_FILE goto MENU
set "LIST_FILE=!LIST_FILE:"=!"
if not exist "!LIST_FILE!" (
    echo [!] Файл "!LIST_FILE!" не знайдено!
    pause
    goto MENU
)
echo.
"!PYTHON_CMD!" "%~dp0get_htm.py" --file "!LIST_FILE!" --skip-existing --delay 0.25
echo.
pause
goto MENU

:DOWNLOAD_BENCHMARK
echo.
echo ----------------------------------------------------------------
echo  [5] Швидке завантаження 5 основних законів і кодексів...
echo ----------------------------------------------------------------
echo.
"!PYTHON_CMD!" "%~dp0get_htm.py" 322-08 4742-20 254к/96-вр 2341-14 435-15 --skip-existing
echo.
pause
goto MENU

:OPEN_FOLDER
explorer "%~dp0"
goto MENU

:EXIT_APP
exit /b 0
