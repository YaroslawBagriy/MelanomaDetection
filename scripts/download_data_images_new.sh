#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

TRAIN_FILE_ID="1TMdtD37o6d5HQnDcERk62RrSlHI3X3az"
TEST_FILE_ID="1SlCkVubzGfUlnbHbOKUxbULXqygEQrhu"

DATA_DIR="${ROOT_DIR}/data/images_new"
TRAIN_DIR="${DATA_DIR}/train"
TEST_DIR="${DATA_DIR}/test"
TRAIN_ZIP="${DATA_DIR}/train.zip"
TEST_ZIP="${DATA_DIR}/test.zip"

mkdir -p "${DATA_DIR}"

echo "Root directory: ${ROOT_DIR}"
echo "Train output: ${TRAIN_DIR}"
echo "Test output: ${TEST_DIR}"
echo

if command -v python3 >/dev/null 2>&1; then
    PYTHON_CMD="python3"
elif command -v python >/dev/null 2>&1; then
    PYTHON_CMD="python"
else
    echo "ERROR: Python was not found."
    exit 1
fi

echo "Using Python: ${PYTHON_CMD}"
echo

"${PYTHON_CMD}" -m pip install --upgrade pip
"${PYTHON_CMD}" -m pip install requests

rm -rf "${TRAIN_DIR}" "${TEST_DIR}"
mkdir -p "${TRAIN_DIR}" "${TEST_DIR}"

download_from_drive() {
    local file_id="$1"
    local out_path="$2"

    "${PYTHON_CMD}" - <<PY
from pathlib import Path
import re
import sys
from urllib.parse import urljoin
import requests

file_id = "${file_id}"
out_path = Path(r"${out_path}")

session = requests.Session()
base_url = "https://drive.google.com/uc?export=download"
resp = session.get(base_url, params={"id": file_id}, stream=True)
resp.raise_for_status()

content_type = resp.headers.get("Content-Type", "")
disposition = resp.headers.get("Content-Disposition", "")

def save_stream(response, path: Path):
    with open(path, "wb") as f:
        for chunk in response.iter_content(chunk_size=1024 * 1024):
            if chunk:
                f.write(chunk)

if "application/zip" in content_type.lower() or "attachment" in disposition.lower():
    save_stream(resp, out_path)
    print(f"Downloaded file directly to {out_path}")
    sys.exit(0)

text = resp.text

form_action_match = re.search(r'<form[^>]+id="download-form"[^>]+action="([^"]+)"', text)
if not form_action_match:
    form_action_match = re.search(r'<form[^>]+action="([^"]+)"', text)

if not form_action_match:
    preview = text[:500].replace("\\n", " ")
    raise SystemExit(
        "Could not find Google Drive download form. "
        f"Response content-type={content_type!r}. "
        f"Response preview: {preview}"
    )

action = form_action_match.group(1).replace("&amp;", "&")
download_url = urljoin("https://drive.google.com", action)

inputs = dict(re.findall(r'<input[^>]+name="([^"]+)"[^>]+value="([^"]*)"', text))
if "id" not in inputs:
    inputs["id"] = file_id

resp2 = session.get(download_url, params=inputs, stream=True)
resp2.raise_for_status()

content_type2 = resp2.headers.get("Content-Type", "")
disposition2 = resp2.headers.get("Content-Disposition", "")

if not ("application/zip" in content_type2.lower() or "attachment" in disposition2.lower()):
    preview_chunks = []
    for chunk in resp2.iter_content(chunk_size=1024):
        if chunk:
            preview_chunks.append(chunk)
        if sum(len(c) for c in preview_chunks) >= 1024:
            break
    preview = b"".join(preview_chunks)[:200]
    raise SystemExit(
        "Second request did not return a zip file. "
        f"Content-Type={content_type2!r}, Content-Disposition={disposition2!r}, "
        f"First bytes={preview!r}"
    )

with open(out_path, "wb") as f:
    for chunk in resp2.iter_content(chunk_size=1024 * 1024):
        if chunk:
            f.write(chunk)

print(f"Downloaded confirmed file to {out_path}")
PY
}

echo "Downloading train.zip..."
download_from_drive "${TRAIN_FILE_ID}" "${TRAIN_ZIP}"

echo
echo "Downloading test.zip..."
download_from_drive "${TEST_FILE_ID}" "${TEST_ZIP}"

echo
echo "Extracting and cleaning train.zip..."
"${PYTHON_CMD}" - <<PY
from pathlib import Path
import shutil
import zipfile

zip_path = Path(r"${TRAIN_ZIP}")
out_dir = Path(r"${TRAIN_DIR}")

if not zipfile.is_zipfile(zip_path):
    raise SystemExit(f"{zip_path} is not a valid zip file")

with zipfile.ZipFile(zip_path, "r") as zf:
    zf.extractall(out_dir)

# Remove __MACOSX if present
macosx_dir = out_dir / "__MACOSX"
if macosx_dir.exists():
    shutil.rmtree(macosx_dir)

# Flatten nested train folder if zip extracts train/train/*
nested = out_dir / "train"
if nested.exists() and nested.is_dir():
    for item in nested.iterdir():
        shutil.move(str(item), str(out_dir / item.name))
    nested.rmdir()

# Remove any nested __MACOSX again after flattening
macosx_dir = out_dir / "__MACOSX"
if macosx_dir.exists():
    shutil.rmtree(macosx_dir)

print(f"Extracted and cleaned {zip_path} -> {out_dir}")
PY

echo
echo "Extracting and cleaning test.zip..."
"${PYTHON_CMD}" - <<PY
from pathlib import Path
import shutil
import zipfile

zip_path = Path(r"${TEST_ZIP}")
out_dir = Path(r"${TEST_DIR}")

if not zipfile.is_zipfile(zip_path):
    raise SystemExit(f"{zip_path} is not a valid zip file")

with zipfile.ZipFile(zip_path, "r") as zf:
    zf.extractall(out_dir)

# Remove __MACOSX if present
macosx_dir = out_dir / "__MACOSX"
if macosx_dir.exists():
    shutil.rmtree(macosx_dir)

# Flatten nested test folder if zip extracts test/test/*
nested = out_dir / "test"
if nested.exists() and nested.is_dir():
    for item in nested.iterdir():
        shutil.move(str(item), str(out_dir / item.name))
    nested.rmdir()

# Remove any nested __MACOSX again after flattening
macosx_dir = out_dir / "__MACOSX"
if macosx_dir.exists():
    shutil.rmtree(macosx_dir)

print(f"Extracted and cleaned {zip_path} -> {out_dir}")
PY

rm -f "${TRAIN_ZIP}" "${TEST_ZIP}"

echo
echo "Done."
echo "Files are now in:"
echo "  ${TRAIN_DIR}"
echo "  ${TEST_DIR}"