#!/usr/bin/env bash
set -euo pipefail

dir="${1:-.}"
outfile="${2:-checksums.txt}"

outfile_abs=$(readlink -f -- "$outfile" 2>/dev/null || printf "%s" "$outfile")

tmp=$(mktemp) || exit 1
trap 'rm -f -- "$tmp"' EXIT

#just normal file no directories, no recursion
while IFS= read -r -d '' f; do
  #skip output file itself
  f_abs=$(readlink -f -- "$f" 2>/dev/null || printf "%s" "$f")
  [ "$f_abs" = "$outfile_abs" ] && continue

  md5=$(md5sum -- "$f" | awk '{print $1}')
  sha=$(sha256sum -- "$f" | awk '{print $1}')
  printf '%s & %s & %s \\\\ \n' "$f" "$md5" "$sha" >> "$tmp"
done < <(find "$dir" -maxdepth 1 -type f -print0)

mv "$tmp" "$outfile"
echo "Checksums scritti in: $outfile"