# UTF-8 인코딩 설정
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "====================================" -ForegroundColor Cyan
Write-Host "PNG 알파 채널 제거 도구" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Python 설치 확인
try {
    $pythonVersion = python --version 2>&1
    Write-Host "Python 확인: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "[오류] Python이 설치되어 있지 않습니다." -ForegroundColor Red
    Write-Host "Python을 설치해주세요: https://www.python.org/downloads/"
    Read-Host "Enter 키를 눌러 종료하세요"
    exit 1
}

# 가상환경 확인 및 생성
if (-Not (Test-Path "venv")) {
    Write-Host "가상환경을 생성합니다..." -ForegroundColor Yellow
    python -m venv venv
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[오류] 가상환경 생성에 실패했습니다." -ForegroundColor Red
        Read-Host "Enter 키를 눌러 종료하세요"
        exit 1
    }
    Write-Host "가상환경 생성 완료!" -ForegroundColor Green
    Write-Host ""
}

# 가상환경 활성화
Write-Host "가상환경 활성화 중..." -ForegroundColor Yellow
& ".\venv\Scripts\Activate.ps1"

# Pillow 설치 확인
Write-Host "Pillow 라이브러리 확인 중..." -ForegroundColor Yellow
python -c "import PIL" 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Pillow를 설치합니다..." -ForegroundColor Yellow
    pip install Pillow
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[오류] Pillow 설치에 실패했습니다." -ForegroundColor Red
        Read-Host "Enter 키를 눌러 종료하세요"
        exit 1
    }
    Write-Host "Pillow 설치 완료!" -ForegroundColor Green
    Write-Host ""
}

# Python 스크립트 실행
Write-Host "처리 시작..." -ForegroundColor Cyan
Write-Host ""
python main.py

# 가상환경 비활성화
deactivate

Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "완료! 결과를 확인해주세요." -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Cyan
Read-Host "Enter 키를 눌러 종료하세요"
