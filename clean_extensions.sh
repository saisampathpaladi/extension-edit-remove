#!/bin/bash

read -p "Enter folder path (default: current folder): " folder
folder=${folder:-.}

if [ ! -d "$folder" ]; then
  echo "Invalid folder"
  exit 1
fi

cd "$folder" || exit

# Get unique extensions
exts=$(find . -maxdepth 1 -type f -name "*.*" | sed -E 's/.*\.([^./]+)$/\1/' | sort | uniq)

echo "Found extensions:"
i=1
declare -A ext_map
for ext in $exts; do
  echo "$i) .$ext"
  ext_map[$i]=$ext
  ((i++))
done

echo "Enter numbers of extensions to remove (comma-separated, e.g., 1,3):"
read input

IFS=',' read -ra choices <<< "$input"

read -p "Enter new extension to add (optional, no dot): " newext

for c in "${choices[@]}"; do
  sel="${ext_map[$c]}"
  if [ -z "$sel" ]; then
    echo "Invalid option: $c"
    continue
  fi
  echo "Removing .$sel from filenames..."
  for f in *."$sel"; do
    new="${f%.$sel}"
    if [ -n "$newext" ]; then
      new="${new}.${newext}"
    fi
    if [ ! -e "$new" ]; then
      mv "$f" "$new"
      echo "Renamed: $f -> $new"
    fi
  done
done

echo "Done."

