# https://cheatography.com/linux-china/cheat-sheets/justfile/

alias tdd := watch

build:
  rm pocketrocketry.zip
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
