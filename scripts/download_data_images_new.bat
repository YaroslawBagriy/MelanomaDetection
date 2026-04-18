@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%\..") do set "ROOT_DIR=%%~fI"

set "TRAIN_FILE_ID=1TMdtD37o6d5HQnDcERk62RrSlHI3X3az"
set "TEST_FILE_ID=1SlCkVubzGfUlnbHbOKUxbULXqygEQrhu"

set "DATA_DIR=%ROOT_DIR%\data\images_new"
set "TRAIN_DIR=%DATA_DIR%\train"
set "TEST_DIR=%DATA_DIR%\test"
set "TRAIN_ZIP=%DATA_DIR%\train.zip"
set "TEST_ZIP=%DATA_DIR%\test.zip"

if not exist "%DATA_DIR%" mkdir "%DATA_DIR%"

echo Root directory: %ROOT_DIR%
echo Train output: %TRAIN_DIR%
echo Test output: %TEST_DIR%
echo.

py -3 --version >nul 2>nul
if %errorlevel%==0 (
    set "PYTHON_CMD=py -3"
) else (
    python --version >nul 2>nul
    if errorlevel 1 goto :python_missing
    set "PYTHON_CMD=python"
)

echo Using Python: %PYTHON_CMD%
echo.

%PYTHON_CMD% -m pip install --upgrade pip
if errorlevel 1 goto :pip_error

%PYTHON_CMD% -m pip install requests
if errorlevel 1 goto :pip_error

if exist "%TRAIN_DIR%" rmdir /s /q "%TRAIN_DIR%"
if exist "%TEST_DIR%" rmdir /s /q "%TEST_DIR%"

mkdir "%TRAIN_DIR%"
mkdir "%TEST_DIR%"

echo Downloading train.zip...
%PYTHON_CMD% -c "from pathlib import Path; import re, sys, requests; from urllib.parse import urljoin; file_id=r'%TRAIN_FILE_ID%'; out_path=Path(r'%TRAIN_ZIP%'); session=requests.Session(); base_url='https://drive.google.com/uc?export=download'; resp=session.get(base_url, params={'id': file_id}, stream=True); resp.raise_for_status(); content_type=resp.headers.get('Content-Type',''); disposition=resp.headers.get('Content-Disposition',''); \
def save_stream(response, path): \
    with open(path, 'wb') as f: \
        for chunk in response.iter_content(chunk_size=1024*1024): \
            if chunk: \
                f.write(chunk); \
if 'application/zip' in content_type.lower() or 'attachment' in disposition.lower(): \
    save_stream(resp, out_path); \
    print(f'Downloaded file directly to {out_path}'); \
    sys.exit(0); \
text = resp.text; \
form_action_match = re.search(r'<form[^>]+id=\"download-form\"[^>]+action=\"([^\"]+)\"', text); \
if not form_action_match: \
    form_action_match = re.search(r'<form[^>]+action=\"([^\"]+)\"', text); \
if not form_action_match: \
    preview = text[:500].replace('\n', ' '); \
    raise SystemExit(f'Could not find Google Drive download form. Response content-type={content_type!r}. Response preview: {preview}'); \
action = form_action_match.group(1).replace('&amp;', '&'); \
download_url = urljoin('https://drive.google.com', action); \
inputs = dict(re.findall(r'<input[^>]+name=\"([^\"]+)\"[^>]+value=\"([^\"]*)\"', text)); \
if 'id' not in inputs: \
    inputs['id'] = file_id; \
resp2 = session.get(download_url, params=inputs, stream=True); \
resp2.raise_for_status(); \
content_type2 = resp2.headers.get('Content-Type', ''); \
disposition2 = resp2.headers.get('Content-Disposition', ''); \
if not ('application/zip' in content_type2.lower() or 'attachment' in disposition2.lower()): \
    preview_chunks = []; \
    total = 0; \
    for chunk in resp2.iter_content(chunk_size=1024): \
        if chunk: \
            preview_chunks.append(chunk); \
            total += len(chunk); \
        if total >= 1024: \
            break; \
    preview = b''.join(preview_chunks)[:200]; \
    raise SystemExit(f'Second request did not return a zip file. Content-Type={content_type2!r}, Content-Disposition={disposition2!r}, First bytes={preview!r}'); \
with open(out_path, 'wb') as f: \
    for chunk in resp2.iter_content(chunk_size=1024*1024): \
        if chunk: \
            f.write(chunk); \
print(f'Downloaded confirmed file to {out_path}')"
if errorlevel 1 goto :download_error

echo.
echo Downloading test.zip...
%PYTHON_CMD% -c "from pathlib import Path; import re, sys, requests; from urllib.parse import urljoin; file_id=r'%TEST_FILE_ID%'; out_path=Path(r'%TEST_ZIP%'); session=requests.Session(); base_url='https://drive.google.com/uc?export=download'; resp=session.get(base_url, params={'id': file_id}, stream=True); resp.raise_for_status(); content_type=resp.headers.get('Content-Type',''); disposition=resp.headers.get('Content-Disposition',''); \
def save_stream(response, path): \
    with open(path, 'wb') as f: \
        for chunk in response.iter_content(chunk_size=1024*1024): \
            if chunk: \
                f.write(chunk); \
if 'application/zip' in content_type.lower() or 'attachment' in disposition.lower(): \
    save_stream(resp, out_path); \
    print(f'Downloaded file directly to {out_path}'); \
    sys.exit(0); \
text = resp.text; \
form_action_match = re.search(r'<form[^>]+id=\"download-form\"[^>]+action=\"([^\"]+)\"', text); \
if not form_action_match: \
    form_action_match = re.search(r'<form[^>]+action=\"([^\"]+)\"', text); \
if not form_action_match: \
    preview = text[:500].replace('\n', ' '); \
    raise SystemExit(f'Could not find Google Drive download form. Response content-type={content_type!r}. Response preview: {preview}'); \
action = form_action_match.group(1).replace('&amp;', '&'); \
download_url = urljoin('https://drive.google.com', action); \
inputs = dict(re.findall(r'<input[^>]+name=\"([^\"]+)\"[^>]+value=\"([^\"]*)\"', text)); \
if 'id' not in inputs: \
    inputs['id'] = file_id; \
resp2 = session.get(download_url, params=inputs, stream=True); \
resp2.raise_for_status(); \
content_type2 = resp2.headers.get('Content-Type', ''); \
disposition2 = resp2.headers.get('Content-Disposition', ''); \
if not ('application/zip' in content_type2.lower() or 'attachment' in disposition2.lower()): \
    preview_chunks = []; \
    total = 0; \
    for chunk in resp2.iter_content(chunk_size=1024): \
        if chunk: \
            preview_chunks.append(chunk); \
            total += len(chunk); \
        if total >= 1024: \
            break; \
    preview = b''.join(preview_chunks)[:200]; \
    raise SystemExit(f'Second request did not return a zip file. Content-Type={content_type2!r}, Content-Disposition={disposition2!r}, First bytes={preview!r}'); \
with open(out_path, 'wb') as f: \
    for chunk in resp2.iter_content(chunk_size=1024*1024): \
        if chunk: \
            f.write(chunk); \
print(f'Downloaded confirmed file to {out_path}')"
if errorlevel 1 goto :download_error

echo.
echo Extracting and cleaning train.zip...
%PYTHON_CMD% -c "from pathlib import Path; import shutil, zipfile; zip_path=Path(r'%TRAIN_ZIP%'); out_dir=Path(r'%TRAIN_DIR%'); \
if not zipfile.is_zipfile(zip_path): raise SystemExit(f'{zip_path} is not a valid zip file'); \
with zipfile.ZipFile(zip_path, 'r') as zf: zf.extractall(out_dir); \
macosx_dir = out_dir / '__MACOSX'; \
if macosx_dir.exists(): shutil.rmtree(macosx_dir); \
nested = out_dir / 'train'; \
if nested.exists() and nested.is_dir(): \
    for item in nested.iterdir(): \
        shutil.move(str(item), str(out_dir / item.name)); \
    nested.rmdir(); \
macosx_dir = out_dir / '__MACOSX'; \
if macosx_dir.exists(): shutil.rmtree(macosx_dir); \
print(f'Extracted and cleaned {zip_path} -> {out_dir}')"
if errorlevel 1 goto :extract_error

echo.
echo Extracting and cleaning test.zip...
%PYTHON_CMD% -c "from pathlib import Path; import shutil, zipfile; zip_path=Path(r'%TEST_ZIP%'); out_dir=Path(r'%TEST_DIR%'); \
if not zipfile.is_zipfile(zip_path): raise SystemExit(f'{zip_path} is not a valid zip file'); \
with zipfile.ZipFile(zip_path, 'r') as zf: zf.extractall(out_dir); \
macosx_dir = out_dir / '__MACOSX'; \
if macosx_dir.exists(): shutil.rmtree(macosx_dir); \
nested = out_dir / 'test'; \
if nested.exists() and nested.is_dir(): \
    for item in nested.iterdir(): \
        shutil.move(str(item), str(out_dir / item.name)); \
    nested.rmdir(); \
macosx_dir = out_dir / '__MACOSX'; \
if macosx_dir.exists(): shutil.rmtree(macosx_dir); \
print(f'Extracted and cleaned {zip_path} -> {out_dir}')"
if errorlevel 1 goto :extract_error

del "%TRAIN_ZIP%"
del "%TEST_ZIP%"

echo.
echo Done.
echo Files are now in:
echo   %TRAIN_DIR%
echo   %TEST_DIR%
goto :eof

:python_missing
echo ERROR: Python was not found.
exit /b 1

:pip_error
echo ERROR: Failed to install pip packages.
exit /b 1

:download_error
echo ERROR: Download failed.
exit /b 1

:extract_error
echo ERROR: Extraction failed.
exit /b 1