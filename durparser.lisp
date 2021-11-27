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
  ((minutes
    :initarg :minutes
    :initform nil)
   (seconds
    :initarg :seconds
    :initform nil)))

(defun print-duration (d)
  (format nil "~@[~dm~]~@[~ds~]"
          (slot-value d 'minutes)
          (slot-value d 'seconds)))
