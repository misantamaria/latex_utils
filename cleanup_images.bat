@echo off
setlocal enabledelayedexpansion

REM Ruta a las imágenes
set IMAGES_PATH=.\images
REM Ruta a las secciones
set SECTIONS_PATH=..\sections

REM Cambiar a directorio de imágenes
pushd %IMAGES_PATH%
echo Current Directory: %CD%

REM Recorrer cada archivo en el directorio de imágenes
for %%f in (*) do (
    echo Checking file: %%f
    set "found=0"

    REM Cambiar a directorio de secciones para buscar en archivos .tex
    pushd %SECTIONS_PATH%

    REM Buscar el nombre del archivo (sin extensión) en los archivos .tex en el directorio de secciones
    for /r %%s in (*.tex) do (
        echo Searching for %%~nf in %%s
        findstr /m /c:"%%~nf" "%%s" >nul
        if !errorlevel! equ 0 (
            set "found=1"
            echo %%~nxf referenced in %%s
            goto :continue_search
        )
    )

    REM Volver al directorio de imágenes
    popd

    :continue_search
    REM Si el archivo no fue encontrado en ningún .tex, pedir confirmación para eliminarlo
    if !found! equ 0 (
        echo %%~nxf not referenced. Press Enter to delete, or Ctrl+C to cancel.
        pause >nul
        del "%%f"
        echo Deleted %%~nxf
    )
)

echo Cleanup complete
popd
endlocal
pause
