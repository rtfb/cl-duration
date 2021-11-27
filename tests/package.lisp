(ql:quickload :fiveam)
(ql:quickload :duration)
(defpackage #:duration-tests
  (:use #:cl #:fiveam #:duration)
  (:export #:run!
           #:all-tests
           #:test-duration))
