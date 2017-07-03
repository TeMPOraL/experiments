(in-package #:trc.experiments)

;;;; Combined hash table accessor with compiler macro optimizing it.
;;; TODO figure out how to make separator for split-sequence parametrized in such a way it can
;;; be changed for compiler-macro in a correct way.

;;; Base implementation
(defun %href (object &rest keys)
  (check-type object hash-table)
  (loop for remaining-keys on keys
     for datum = (gethash (first remaining-keys) object) then (gethash (first remaining-keys) datum)
     do (when (rest remaining-keys)
          (check-type datum hash-table))
     finally (return datum)))

(defun href (object key &rest keys)
  (flet ((canonicalize-keys ()
           (mapcan (curry #'split-sequence:split-sequence #\/) (cons key keys))))
   (apply #'%href object (canonicalize-keys))))

;;; Compiler macro

(define-compiler-macro href (&whole form
                                    object
                                    &rest keys)
  (declare (ignore form))
  (labels ((canonicalize-constant-keys (all-keys)
             (mapcan (lambda (key)
                       (if (and (constantp key)
                                (stringp key))
                           (split-sequence:split-sequence #\/ key)
                           (list key)))
                     all-keys))
           (build-call (obj &rest rev-keys)
             (if (cdr rev-keys)
                 `(gethash ,(car rev-keys) ,(apply #'build-call obj (rest rev-keys)))
                 `(gethash ,(car rev-keys) ,obj))))
    (apply #'build-call object (reverse (canonicalize-constant-keys keys)))))

