(in-package #:durparser-tests)

(def-suite all-tests
    :description "The master suite of all durparser tests.")

(in-suite all-tests)

(defun test-durparser ()
  (run! 'all-tests))

(test foo-returns-seven
  (is (= 7 (durparser::foo))))
