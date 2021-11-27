test:
	sbcl --noinform --eval '(asdf:test-system "durparser/tests")' --quit

install-deps:
	sbcl --noinform --eval '(ql:quickload "fiveam")' --quit
