if not exist data mkdir data
if not exist data\images mkdir data\images
if not exist data\images\train mkdir data\images\train
if not exist data\images\val mkdir data\images\val
if not exist data\images\test mkdir data\images\test

echo Downloading TRAIN images...
gdown --folder --remaining-ok "https://drive.google.com/drive/folders/10xSPHYq54MgvqadB5mNusnruGTSEMDPn?usp=sharing" -O data\images\train
if errorlevel 1 goto :error

echo Downloading VAL images...
gdown --folder --remaining-ok "https://drive.google.com/drive/folders/1WzggtnsWj68p2_o0qQYuNmM9BAvTXgCj?usp=sharing" -O data\images\val
if errorlevel 1 goto :error

echo Downloading TEST images...
gdown --folder --remaining-ok "https://drive.google.com/drive/folders/1GLek8oiK1L0aBaiAvkHXcmjurTDb8bi2?usp=sharing" -O data\images\test
if errorlevel 1 goto :error

echo.
echo Download complete.
echo Current folders:
dir data\images /ad /s
goto :eof

:error
echo.
echo Download failed.
echo Make sure:
echo 1. Python is installed
echo 2. gdown is installed with: pip install gdown
echo 3. You ran this from the repo root
exit /b 1