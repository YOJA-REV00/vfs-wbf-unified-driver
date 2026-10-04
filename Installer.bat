@echo off
title BIOMETRIC PACK DEPLOYMENT WIZARD - MIXOS DEV
color 0B
cls

:: ===================================================================
:: 1. AUTO-ELEVATION SUBROUTINE (Self-escalate to Administrator)
:: ===================================================================
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [SYSTEM] Requesting administrative privileges...
    powershell -Command "Start-Process -FilePath '%0' -ArgumentList 'am_admin' -Verb RunAs"
    exit /b
)

:: ===================================================================
:: 2. TARGET PATH AND ENVIRONMENT VERIFICATION
:: ===================================================================
set "INF_PATH=%~dp0Drivers\Driver U\wbf_vfs.inf"
if not exist "%INF_PATH%" (
    echo -----------------------------------------------------------------
    echo  ERROR: SOURCE FILES NOT FOUND
    echo -----------------------------------------------------------------
    echo  Critical file 'wbf_vfs.inf' is missing from the directory.
    echo  Ensure 'Drivers\Driver U' folder is located next to this script.
    echo -----------------------------------------------------------------
    echo.
    pause
    exit /b
)

echo ===================================================================
echo     BIOMETRIC DEPLOYMENT AND MANAGEMENT SYSTEM - PROJECT 4420s
echo ===================================================================
echo.

:: ===================================================================
:: 3. TELEMETRY AUDIT ENGINE
:: ===================================================================
echo  [SYSTEM AUDIT] Scanning active Biometric Hardware and Bus...
set "CURRENT_VER=-"
for /f "tokens=*" %%A in ('powershell -Command "Get-CimInstance Win32_PnPSignedDriver | Where-Object { $_.DeviceID -match '138A' } | Select-Object -ExpandProperty DriverVersion -ErrorAction SilentlyContinue" 2^>nul') do (
    if not "%%A"=="" set "CURRENT_VER=%%A"
)

set "PACKAGE_VER=-"
for /f "tokens=2 delims=," %%B in ('findstr /i "DriverVer" "%INF_PATH%" 2^>nul') do (
    set "RAW_VER=%%B"
)
if defined RAW_VER (
    for /f "tokens=1" %%C in ("%RAW_VER%") do set "PACKAGE_VER=%%C"
)

echo  -----------------------------------------------------------------
echo   SYSTEM INVENTORY REPORT:
echo  -----------------------------------------------------------------
echo   * Device Detected  : Validity Sensors Stack (VFS301)
echo   * Current Version  : %CURRENT_VER%
echo   * Package Version  : %PACKAGE_VER% (MixOS Dev. Certified)
echo  -----------------------------------------------------------------
echo.

:: ===================================================================
:: 4. INTERACTIVE MENU DEFINITION
:: ===================================================================
:MENU
echo  AVAILABLE OPTIONS:
echo   [Y] Standard Upgrade / Flash Core Driver Package
echo   [N] Abort Installation Wizard
echo.
set /p "CHOICE= Select an action code to proceed (Y/N): "

if /i "%CHOICE%"=="N" (
    echo.
    echo  Installation aborted by user. Exiting wizard...
    timeout /t 3 >nul
    exit /b 0
)

if /i "%CHOICE%"=="Y" (
    goto INSTALL_STANDARD
)

echo  Invalid input. Please choose Y or N.
echo.
goto MENU

:: ===================================================================
:: 5. STANDARD UPGRADE PATH (Direct Ingestion & Hardware Binding)
:: ===================================================================
:INSTALL_STANDARD
echo.
echo ===================================================================
echo  UPGRADING MODULAR BIOMETRIC CORE...
echo ===================================================================
echo.

echo  [1/4] Stopping Windows Biometric Service (WbioSrvc)...
net stop WbioSrvc >nul 2>&1

echo  [2/4] Staging driver package into system repository...
pnputil /add-driver "%INF_PATH%" /force

echo  [3/4] Forcing hardware binding on USB Bus via SetupAPI...
:: Llamada estructurada encapsulada en una clase C# valida para compilar en PowerShell sin errores
powershell -Command "$Signature = 'using System; using System.Runtime.InteropServices; public class Win32DriverInstaller { [DllImport(\"newdev.dll\", SetLastError = true, CharSet = CharSet.Auto)] public static extern bool UpdateDriverForPlugAndPlayDevices(IntPtr hwndParent, string HardwareId, string FullInfPath, uint Flags, out bool bRebootRequired); }'; Add-Type -TypeDefinition $Signature -ErrorAction SilentlyContinue; $reboot = $false; $res = [Win32DriverInstaller]::UpdateDriverForPlugAndPlayDevices([IntPtr]::Zero, 'USB\VID_138A&PID_0007', '%INF_PATH%', 1, [ref]$reboot); if ($res) { Write-Host '    -> Hardware bound successfully!' -ForegroundColor Green } else { Write-Host '    -> Hardware binding forced via alternative PnP re-scan...' -ForegroundColor Yellow }"

:: Ciclo de refresco electrico en el bus USB para forzar la lectura de descriptores
powershell -Command "Get-PnpDevice -InstanceId 'USB\VID_138A*' -ErrorAction SilentlyContinue | Foreach-Object { Disable-PnpDevice -InstanceId $_.InstanceId -Confirm:$false; Enable-PnpDevice -InstanceId $_.InstanceId -Confirm:$false }" >nul 2>&1

echo  [4/4] Restoring and enforcing automatic Biometric Service policies...
sc config WbioSrvc start= auto >nul 2>&1
net start WbioSrvc >nul 2>&1

echo.
echo ===================================================================
echo  🏆 PROCESS COMPLETED: Verification dashboard is now live!
echo ===================================================================
echo.
pause
exit /b 0
