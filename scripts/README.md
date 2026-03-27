## Downloading the dataset on Windows

### Prerequisites
- Python installed
- `pip` installed
- `gdown` installed

Install `gdown` with:

```bash
pip install gdown

============================================
MelanomaDetection dataset download script
============================================
Prerequisites:
1. Python must be installed
2. pip must be available
3. gdown must be installed:
    pip install gdown

How to run:
1. Open Command Prompt
2. Change directory to the root of the repo, for example:
    cd C:\Users\YourName\Documents\MelanomaDetection
3. Run:
    scripts\download_data.bat

What this script does:
- Creates data\images\train
- Creates data\images\val
- Creates data\images\test
- Downloads the Google Drive image subsets into those folders

Notes:
- Run this script from the ROOT of the repo
- The data folder should be in .gitignore so images are not committed
============================================