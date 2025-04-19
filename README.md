# extension-edit-remove
---

# 🐚 Extension Cleaner - Shell Script

A lightweight and easy-to-use **shell script** that scans files in a folder, detects unusual extensions (like `.mp4.fdmdownload`), and allows you to bulk clean them by:

- Removing unwanted extensions
- Optionally adding a new one (like `.mp4`)
  
---

## ✨ Features

- Lists all unique file extensions in a folder
- Allows you to select extensions to remove via number-based menu
- Optional addition of a new extension
- Default folder is the current working directory
- Works on Linux, macOS, and WSL environments

---

## 💾 Setup

### ✅ Requirements

- Any Unix-like terminal (Bash shell)

### 📁 Save the Script

Save the following script as `clean_ext.sh`:

```bash
#!/bin/bash

echo "=== Extension Cleaner Shell Script ==="
read -p "Enter folder path (default: current folder): " folder
folder=${folder:-$(pwd)}

cd "$folder" || { echo "Folder not found."; exit 1; }

echo "Scanning for files..."
mapfile -t extensions < <(find . -type f | grep -oE '\.[^./]+\.[^/]+' | sed 's/.*\.//' | sort | uniq)

if [ ${#extensions[@]} -eq 0 ]; then
    echo "No compound extensions found."
    exit 0
fi

echo "Select extensions to remove (comma separated):"
for i in "${!extensions[@]}"; do
    echo "$((i+1))) .${extensions[i]}"
done

read -p "Enter choice (e.g., 1,3): " choices
IFS=',' read -r -a indexes <<< "$choices"

read -p "Enter new extension to add (or leave blank to skip): " new_ext

for index in "${indexes[@]}"; do
    ext="${extensions[index-1]}"
    echo "Processing files with .$ext..."

    for file in *.$ext; do
        [ -e "$file" ] || continue
        base="${file%.*}"
        if [ -n "$new_ext" ]; then
            mv "$file" "$base.$new_ext"
        else
            mv "$file" "$base"
        fi
    done
done

echo "✅ Done."
```

### 🔐 Make It Executable

```bash
chmod +x clean_ext.sh
```

---

## 🚀 How to Run

```bash
./clean_ext.sh
```

Follow the on-screen prompts:
1. Enter a folder path or press Enter for current folder.
2. Select extensions to remove.
3. Optionally enter a new extension to append.

---

## 📦 Example

Before:
```
video1.mp4.fdmdownload
video2.mp4.fdmdownload
```

Run the script → remove `.fdmdownload` and add `.mp4`

After:
```
video1.mp4
video2.mp4
```

---

## 📄 License

This script is free to use for **personal and educational** purposes only. Commercial use is not allowed.

---

## 👤 Author

**Sampath Sai Paladi**  
📧 saisampathpaladi@gmail.com  
🌐 https://saisampathpaladi.github.io/portfolio/ 
📎 https://saisampathpaladi.github.io/portfolio/src/resume.pdf

---

```
