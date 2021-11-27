(asdf:defsystem #:duration
  :description "Duration parser"
  :author "Vytautas Šaltenis"
  :components ((:file "package")
               (:file "duration")))

(asdf:defsystem #:duration/tests
  :depends-on (:duration :fiveam)
  :perform (test-op (o s)
                    (uiop:symbol-call :duration-tests :test-duration))
  :components ((:module "tests"
                        :serial t
                        :components ((:file "package")
                                     (:file "main")))))
