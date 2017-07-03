;;; experiments.asd

(asdf:defsystem #:trc.experiments
  :serial t
  :author "Jacek \"TeMPOraL\" Złydach"
  :description "Random experiments."
  :license "MIT"

  :homepage "https://github.com/TeMPOraL/experiments"
  :bug-tracker "https://github.com/TeMPOraL/experiments/issues"
  :source-control (:git "https://github.com/TeMPOraL/experiments.git")
  :mailto "temporal.pl+experiments@gmail.com"

  :encoding :utf-8

  :depends-on (#:alexandria
               #:split-sequence)

  :components ((:module "src"
                        :components ((:file "package")
                                     (:file "compiler-macros"))))

  :in-order-to ((test-op (test-op #:trc.experiments/test))))

(asdf:defsystem #:trc.experiments/test
  :serial t
  :author "Jacek \"TeMPOraL\" Złydach"
  :description "Random experiments (tests system)."
  :license "MIT"

  :homepage "https://github.com/TeMPOraL/experiments"
  :bug-tracker "https://github.com/TeMPOraL/experiments/issues"
  :source-control (:git "https://github.com/TeMPOraL/experiments.git")
  :mailto "temporal.pl+experiments@gmail.com"

  :encoding :utf-8

  :defsystem-depends-on (#:prove-asdf)

  :depends-on (#:trc.experiments
               #:prove)
  
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run) :prove) c))

  :components ((:module "t"
                        :components ((:file "package")
                                     (:test-file "compiler-macros")))))
