# https://cheatography.com/linux-china/cheat-sheets/justfile/

alias tdd := watch

build:
  echo "WandNames = {" > data/scripts/names.lua
  cat wand_names/*.txt > names.list
  sed -ibak -e 's/^/"/' -e 's/$/", /' names.list
  cat names.list >> data/scripts/names.lua
  echo "}" >> data/scripts/names.lua
  rm names.list
  cat data/scripts/names.lua

release: build
  rm -f pocketrocketry.zip
  mkdir pocketrocketry
  cp -r *xml *lua mod_id.txt data pocketrocketry/
  zip pocketrocketry.zip -r pocketrocketry/ 
  rm -rf pocketrocketry 
  echo "pocketrocketry.zip is ready ✅"

test: build
  echo tests are KO ❌

watch:
  ls | entr just test

debt:
  git grep -EI 'TODO|FIXME'
