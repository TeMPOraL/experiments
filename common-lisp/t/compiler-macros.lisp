(in-package #:trc.experiments/test)

(defparameter *test-store* (make-hash-table :test 'equalp))

(plan 3)
(diag "Initializing test data store.")

(setf (gethash "foo" *test-store*) "FOO123")
(setf (gethash "bar" *test-store*) (make-hash-table :test 'equalp))
(setf (gethash "baz" (gethash "bar" *test-store*)) "BARBAZ123")

(diag "Testing.")
(subtest "Base functionality"
  (is (href *test-store* "foo") "FOO123")
  (is (href *test-store* "bar" "baz") "BARBAZ123")
  (is-error (href nil "foo") 'type-error)
  (is-error (href "foobar" "foo") 'type-error)
  (is-error (href *test-store* "foo" "bar") 'type-error)
  (is (href *test-store* "bar" "quux") nil))


(subtest "Splitting keys"
  (is (href *test-store* "bar/baz") "BARBAZ123")
  (is (href *test-store* "bar/quux") nil)
  (is-error (href *test-store* "bar/baz/quux") 'type-error))

(subtest "Compiler macro expansion"
  (isnt (compiler-macro-function 'href) nil)
  (isnt (funcall (compiler-macro-function 'href) '(href obj "foo") nil) nil)
  (is (funcall (compiler-macro-function 'href) '(href obj "foo") nil) '(gethash "foo" obj))
  (is (funcall (compiler-macro-function 'href) '(href obj "foo" "bar") nil) '(gethash "bar" (gethash "foo" obj)))
  (is (funcall (compiler-macro-function 'href) '(href obj "foo/bar") nil) '(gethash "bar" (gethash "foo" obj))))

(finalize)
