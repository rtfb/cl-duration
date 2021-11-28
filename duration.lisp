(in-package #:duration)

(defclass durslot ()
  ((value
    :initarg :value
    :accessor value
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

(defun-macro-helper slot-accessors (slots)
  (loop for slot in slots
        for slotname = (first slot)
        for func-name = (concatenate 'string "set-" (symbol-name slotname))
        collect `(defun ,(intern (string-upcase func-name)) (dur new-value)
                   (setf (value (,slotname dur)) new-value))))

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
                       ,(all-slots slots))))
     ,@(slot-accessors slots)
     ))

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

(defun extract-num-and-suffix (input start)
  (multiple-value-bind (num end-num)
    (parse-integer input :junk-allowed t :start start)
    (let* ((next-num (loop for i from (1+ end-num) to (1- (length input))
                           for ch = (char input i)
                           while (alpha-char-p ch)
                           finally (return i)))
           (suffix (subseq input end-num next-num)))
      (values num suffix next-num))))

(defun parse-parts (input)
  (let (duration (make-duration))
    (loop with index = 0 and num = 0 and suffix = ""
          do (setf (values num suffix index)
                   (extract-num-and-suffix input index))
          collect (list num suffix index)
          ; do (format t "~a ~a ~a~$" num suffix index)
          ; do (funcall (accessor-by-suffix suffix) duration num))))
          while (< index (length input))
          )))

(defun accessor-by-suffix (suffix)
  (cond
    ((string= suffix "w")
     'set-weeks)
    ((string= suffix "d")
     'set-days)
    ((string= suffix "h")
     'set-hours)
    ((string= suffix "m")
     'set-minutes)
    ((string= suffix "s")
     'set-seconds)
    ((string= suffix "ms")
     'set-millis)
    ((string= suffix "μs")
     'set-micros)
    ((string= suffix "ns")
     'set-nanos)))

(defun apply-duration-part (duration partspec)
  (let ((num (first partspec))
        (suffix (second partspec)))
    (funcall (accessor-by-suffix suffix) duration num)))

(defun parse (input)
  (let ((dur (make-duration)))
    (mapcar #'(lambda (partspec)
                (apply-duration-part dur partspec))
            (parse-parts input))
    dur))
