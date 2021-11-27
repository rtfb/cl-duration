(in-package #:duration-tests)

(def-suite all-tests
    :description "The master suite of all duration tests.")

(in-suite all-tests)

(defun test-duration ()
  (run! 'all-tests))

(test durslot->string
  (is (string= "2s" (durslot->string (make-instance 'durslot :value 2)))))

(test empty-durslot
  (is (null (durslot->string (make-instance 'durslot)))))

(test duration-simple-print
  (is (string= "1m" (duration->string (make-duration :minutes 1)))))

(test duration-days
  (is (string= "3d20h53m27s" (duration->string (make-duration
                                                 :days 3
                                                 :hours 20
                                                 :minutes 53
                                                 :seconds 27)))))

(test duration-weeks
  (is (string= "1w32m" (duration->string (make-duration
                                           :weeks 1
                                           :minutes 32)))))

(test duration-prettyprint
  (is (string= "#<DURATION 3m5s>"
               (format nil "~a" (make-duration :minutes 3 :seconds 5)))))
