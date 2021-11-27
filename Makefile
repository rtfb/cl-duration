test:
	sbcl --noinform --eval '(asdf:test-system "duration/tests")' --quit

install-deps:
	sbcl --noinform --eval '(ql:quickload "fiveam")' --quit
