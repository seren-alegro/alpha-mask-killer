@echo off
chcp 65001 > nul
echo ====================================
echo PNG 알파 채널 제거 도구
echo ====================================
echo.

REM Python 설치 확인
python --version >nul 2>&1
if errorlevel 1 (
    echo [오류] Python이 설치되어 있지 않습니다.
    echo Python을 설치해주세요: https://www.python.org/downloads/
    pause
    exit /b 1
)

REM 가상환경 확인 및 생성
if not exist "venv" (
    echo 가상환경을 생성합니다...
    python -m venv venv
    if errorlevel 1 (
        echo [오류] 가상환경 생성에 실패했습니다.
        pause
        exit /b 1
    )
    echo 가상환경 생성 완료!
    echo.
)

REM 가상환경 활성화
echo 가상환경 활성화 중...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo [오류] 가상환경 활성화에 실패했습니다.
    pause
    exit /b 1
)

REM Pillow 설치 확인 및 자동 설치
echo Pillow 라이브러리 확인 중...
python -c "import PIL" >nul 2>&1
if errorlevel 1 (
    echo Pillow를 설치합니다...
    pip install Pillow
    if errorlevel 1 (
        echo [오류] Pillow 설치에 실패했습니다.
        pause
        exit /b 1
    )
    echo Pillow 설치 완료!
    echo.
)

REM Python 스크립트 실행
echo 처리 시작...
echo.
python main.py

REM 가상환경 비활성화
deactivate

echo.
echo ====================================
echo 완료! 결과를 확인해주세요.
echo ====================================
pause
