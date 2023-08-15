# https://cheatography.com/linux-china/cheat-sheets/justfile/

alias tdd := watch

build:
  for f in wand_names/*txt; do \
  BASE=$(basename -s .txt $f); \
  echo "WandNames = {" > data/scripts/$BASE.lua; \
  cat $f > names.list; \
  sed -ibak -e 's/^/"/' -e 's/$/", /' names.list; \
  cat names.list >> data/scripts/$BASE.lua; \
  echo "}" >> data/scripts/$BASE.lua; \
  rm names.list; \
  cat data/scripts/$BASE.lua; \
  done

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
