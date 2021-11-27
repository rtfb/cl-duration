(in-package #:durparser-tests)

(def-suite all-tests
    :description "The master suite of all durparser tests.")

(in-suite all-tests)

(defun test-durparser ()
  (run! 'all-tests))

(test print-durslot
  (is (string= "2s" (print-durslot (make-instance 'durslot :value 2)))))

(test print-empty-durslot
  (is (null (print-durslot (make-instance 'durslot)))))

(test duration-simple-print
  (is (string= "1m" (print-duration (make-instance 'duration
                                                   :minutes 1)))))
