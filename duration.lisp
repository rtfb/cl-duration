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

(defmacro defun-macro-helper (name (&rest args) body)
  `(eval-when (:compile-toplevel :load-toplevel :execute)
     (defun ,name (,@args)
       ,body)))

(defun-macro-helper as-keyword (sym)
  (intern (string sym) :keyword))

(defun-macro-helper slot->defclass-slot (spec)
  (let ((name (first spec)))
    `(,name :initarg ,(as-keyword name) :accessor ,name)))

(defun-macro-helper slot->constructor (spec)
  (let ((name (first spec)))
    `(make-instance 'durslot :value ,name :units ,(second spec))))

(defun-macro-helper slots->constructors (slots)
  (loop for name in (mapcar #'as-keyword (mapcar #'first slots))
        for maker in (mapcar #'slot->constructor slots)
        append (list name maker)))

(defun-macro-helper all-slots (slots)
  `(list ,@(mapcar #'(lambda (spec)
               (list (first spec) 'd))
           slots)))

(defmacro define-duration-class (slots)
  `(progn
     (defclass duration ()
       ,(mapcar #'slot->defclass-slot slots))
     (defun make-duration (&key ,@(mapcar #'first slots))
       (make-instance 'duration
                      ,@(slots->constructors slots)))
     (defun duration->string (d)
       (format nil "~{~@[~a~]~}"
               (mapcar #'(lambda (slot)
                           (when slot
                             (durslot->string slot)))
                       ,(all-slots slots))))))

(define-duration-class
  ((weeks "w")
   (days "d")
   (hours "h")
   (minutes "m")
   (seconds "s")
   (millis "ms")
   (micros "μs")
   (nanos "ns")))

(defmethod print-object ((obj duration) stream)
  (print-unreadable-object (obj stream :type t)
    (format stream "~a" (duration->string obj))))

(defun dm ()
  (macroexpand-1 '(define-duration-class
                    ((days "d")
                     (hours "h")
                     (minutes "m")
                     (seconds "s")))))
