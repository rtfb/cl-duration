(in-package #:durparser)

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
