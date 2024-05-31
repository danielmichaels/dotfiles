#!/bin/bash

tools=(
nuclei
aix
dnsx
katana
simplehttpserver
httpx
tlsx
proxify
naabu
subfinder
)

exists() {
  command -v "$i" 2>/dev/null || return 1
  return 0
}
for i in "${tools[@]}"; do 
  exists "$i" && pdtm -u "$i" || pdtm -i "$i" 
done

pdtm
