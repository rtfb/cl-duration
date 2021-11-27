(asdf:defsystem #:durparser
  :description "Duration parser"
  :author "Vytautas Šaltenis"
  :components ((:file "package")
               (:file "durparser")))

(asdf:defsystem #:durparser/tests
  :depends-on (:durparser :fiveam)
  :perform (test-op (o s)
                    (uiop:symbol-call :durparser-tests :test-durparser))
  :components ((:module "tests"
                        :serial t
                        :components ((:file "package")
                                     (:file "main")))))
