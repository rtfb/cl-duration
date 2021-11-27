(in-package #:duration-tests)

(def-suite all-tests
    :description "The master suite of all duration tests.")

(in-suite all-tests)

(defun test-duration ()
  (run! 'all-tests))

(test print-durslot
  (is (string= "2s" (print-durslot (make-instance 'durslot :value 2)))))

(test print-empty-durslot
  (is (null (print-durslot (make-instance 'durslot)))))

(test duration-simple-print
  (is (string= "1m" (print-duration (make-duration :minutes 1)))))

(test duration-prettyprint
  (is (string= "#<DURATION 3m5s>"
               (format nil "~a" (make-duration :minutes 3 :seconds 5)))))
