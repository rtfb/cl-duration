(in-package #:duration)

(defclass durslot ()
  ((value
    :initarg :value
    :initform nil)
   (units
    :initarg :units
    :initform "s")))

(defun durslot->string (s)
  (with-slots (value units) s
    (when (not (null value))
      (format nil "~d~a" value units))))

(defclass duration ()
  ((days :initarg :days)
   (hours :initarg :hours)
   (minutes :initarg :minutes)
   (seconds :initarg :seconds)))

(defun make-duration (&key days hours minutes seconds)
  (make-instance 'duration
                 :days (make-instance 'durslot :value days :units "d")
                 :hours (make-instance 'durslot :value hours :units "h")
                 :minutes (make-instance 'durslot :value minutes :units "m")
                 :seconds (make-instance 'durslot :value seconds :units "s")))

(defun duration->string (d)
  (format nil "~{~@[~a~]~}"
          (mapcar #'(lambda (slot)
                      (when slot
                        (durslot->string slot)))
                  (list
                    (slot-value d 'days)
                    (slot-value d 'hours)
                    (slot-value d 'minutes)
                    (slot-value d 'seconds)))))

(defmethod print-object ((obj duration) stream)
  (print-unreadable-object (obj stream :type t)
    (format stream "~a" (duration->string obj))))
