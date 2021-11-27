test:
	sbcl --noinform --eval '(asdf:test-system "duration/tests")' --quit

repl:
	sbcl --noinform --eval '(ql:quickload :duration)' --eval '(in-package :duration)'

install-deps:
	sbcl --noinform --eval '(ql:quickload "fiveam")' --quit
