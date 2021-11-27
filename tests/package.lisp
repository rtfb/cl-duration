(ql:quickload :fiveam)
(ql:quickload :durparser)
(defpackage #:durparser-tests
  (:use #:cl #:fiveam #:durparser)
  (:export #:run!
           #:all-tests
           #:test-durparser))
