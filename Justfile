root := justfile_directory()

export TYPST_ROOT := root

[private]
default:
	@just --list --unsorted

# generate manual
doc:
	typst compile docs/manual.typ docs/manual.pdf
	for f in $(find gallery -maxdepth 1 -name '*.typ'); do \
		typst compile "$f"; \
	done
	typst compile --ppi 250 "gallery/thumbnail.typ" "thumbnail.png"

# run test suite
test *args:
	typst-test run {{ args }}

# update test cases
update *args:
	typst-test update {{ args }}

# package the library into the specified destination folder
package target:
  ./scripts/package "{{target}}"

# install the library with the "@local" prefix
install: (package "@local")

# install the library with the "@pria" prefix (for pre-release testing)
install-pria: (package "@pria")

[private]
remove target:
  ./scripts/uninstall "{{target}}"

# uninstalls the library from the "@local" prefix
uninstall: (remove "@local")

# uninstalls the library from the "@pria" prefix (for pre-release testing)
uninstall-pria: (remove "@pria")

# run ci suite
ci: test doc
