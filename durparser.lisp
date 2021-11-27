(in-package #:durparser)

(defclass durslot ()
  ((value
    :initarg :value
    :initform nil)
   (units
    :initarg :units
    :initform "s")))

(defun print-durslot (s)
  (with-slots (value units) s
    (when (not (null value))
      (format nil "~d~a" value units))))

(defclass duration ()
  ((minutes :initarg :minutes)
   (seconds :initarg :seconds)))

(defun make-duration (&key minutes seconds)
  (make-instance 'duration
                 :minutes (make-instance 'durslot :value minutes :units "m")
                 :seconds (make-instance 'durslot :value seconds :units "s")))

(defun print-duration (d)
  (format nil "~{~@[~a~]~}"
          (mapcar #'(lambda (slot)
                      (when slot
                        (print-durslot slot)))
                  (list
                    (slot-value d 'minutes)
                    (slot-value d 'seconds)))))

(defmethod print-object ((obj duration) stream)
  (print-unreadable-object (obj stream :type t)
    (format stream "~a" (print-duration obj))))
