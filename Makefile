PPX_TYPENAME = _build/default/.ppx/ppx_deriving_typename+ppx_driver.runner/ppx.exe

.PHONY: build clean install uninstall reinstall test
build:
	dune build @install

clean:
	dune clean

install:
	dune install

uninstall:
	dune uninstall

reinstall: uninstall install

test:
	dune runtest

test-source:
	$(PPX_TYPENAME) test/run.ml


all: build install test
