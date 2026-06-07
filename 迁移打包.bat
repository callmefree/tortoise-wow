@echo off
chcp 65001 >nul
title WorkBuddy 环境迁移打包工具
echo ============================================
echo  WorkBuddy 完整环境打包工具
echo  当前时间: %date% %time%
echo ============================================
echo.

:: 设置目标路径（打包到 D 盘根目录）
set OUT_DIR=D:\WorkBuddy-Backup-%date:~0,4%%date:~5,2%%date:~8,2%
set ZIP_FILE=%OUT_DIR%.zip

echo 📦 打包目标: %ZIP_FILE%
echo.

:: 确保目标目录存在
if exist "%OUT_DIR%" rmdir /s /q "%OUT_DIR%"
mkdir "%OUT_DIR%"
mkdir "%OUT_DIR%\WorkBuddy-Config"
mkdir "%OUT_DIR%\Project-TurtleWoW"

echo [1/5] 复制 WorkBuddy 配置...
:: 技能目录（核心中最重要）
xcopy /E /I /H /Y "%USERPROFILE%\.workbuddy\skills" "%OUT_DIR%\WorkBuddy-Config\skills\" >nul
:: 记忆文件
xcopy /E /I /H /Y "%USERPROFILE%\.workbuddy\memory" "%OUT_DIR%\WorkBuddy-Config\memory\" >nul
:: 关键配置文件
copy "%USERPROFILE%\.workbuddy\.mcp.json" "%OUT_DIR%\WorkBuddy-Config\" >nul 2>&1
copy "%USERPROFILE%\.workbuddy\mcp.json" "%OUT_DIR%\WorkBuddy-Config\" >nul 2>&1
copy "%USERPROFILE%\.workbuddy\models.json" "%OUT_DIR%\WorkBuddy-Config\" >nul 2>&1
copy "%USERPROFILE%\.workbuddy\settings.json" "%OUT_DIR%\WorkBuddy-Config\" >nul 2>&1
copy "%USERPROFILE%\.workbuddy\MEMORY.md" "%OUT_DIR%\WorkBuddy-Config\" >nul 2>&1
copy "%USERPROFILE%\.workbuddy\SOUL.md" "%OUT_DIR%\WorkBuddy-Config\" >nul 2>&1
copy "%USERPROFILE%\.workbuddy\IDENTITY.md" "%OUT_DIR%\WorkBuddy-Config\" >nul 2>&1
copy "%USERPROFILE%\.workbuddy\USER.md" "%OUT_DIR%\WorkBuddy-Config\" >nul 2>&1
copy "%USERPROFILE%\.workbuddy\BOOTSTRAP.md" "%OUT_DIR%\WorkBuddy-Config\" >nul 2>&1
:: 插件和连接器
xcopy /E /I /H /Y "%USERPROFILE%\.workbuddy\connectors" "%OUT_DIR%\WorkBuddy-Config\connectors\" >nul 2>&1
xcopy /E /I /H /Y "%USERPROFILE%\.workbuddy\plugins" "%OUT_DIR%\WorkBuddy-Config\plugins\" >nul 2>&1
echo ✅ WorkBuddy 配置复制完成

echo [2/5] 复制项目配置...
:: 项目的 .workbuddy 配置（项目级记忆）
xcopy /E /I /H /Y "%~dp0\.workbuddy" "%OUT_DIR%\Project-TurtleWoW\.workbuddy\" >nul
:: bug fix 修复记录（不在 git 中）
xcopy /E /I /H /Y "%~dp0\bug fix" "%OUT_DIR%\Project-TurtleWoW\bug fix\" >nul
echo ✅ 项目配置复制完成

echo [3/5] 导出 Git 凭证信息...
:: 保存远程仓库地址（含 PAT，需要用户在新电脑重新配置）
cd /d "%~dp0"
git remote -v > "%OUT_DIR%\git-remote.txt" 2>&1
git config --local -l > "%OUT_DIR%\git-config.txt" 2>&1
echo ✅ Git 信息导出完成

echo [4/5] 压缩打包...
:: 使用 PowerShell Compress-Archive 压缩（Windows 自带）
powershell -Command "Compress-Archive -Path '%OUT_DIR%\*' -DestinationPath '%ZIP_FILE%' -CompressionLevel Optimal -Force; Write-Host '✅ 打包完成'"
echo ✅ 压缩完成

echo [5/5] 清理临时目录...
rmdir /s /q "%OUT_DIR%"
echo ✅ 清理完成

echo.
echo ============================================
echo  🎉 打包完成！
echo ============================================
echo.
echo  文件位置: %ZIP_FILE%
echo  大小:
dir "%ZIP_FILE%" | find "ZIP"
echo.
echo  将此 ZIP 复制到新电脑即可。
echo  详细安装指南见下方说明。
echo.
echo ============================================
pause
