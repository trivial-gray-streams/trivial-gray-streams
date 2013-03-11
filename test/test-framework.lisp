(in-package :trivial-gray-streams-test)

;;; test framework

(defclass test-result ()
  ((name :type symbol
         :initarg :name
         :initform (error ":name is requierd")
         :accessor name)
   (status :type (or (eql :ok) (eql :fail))
           :initform :ok
           :initarg :status
           :accessor status)
   (cause :type (or null condition)
          :initform nil
          :initarg :cause
          :accessor cause)))

(defun failed-p (test-result)
  (eq (status test-result) :ok))

(defmethod print-object ((r test-result) stream)
  (print-unreadable-object (r stream :type t)
    (format stream "~S ~S~@[ ~A~]" (name r) (status r) (cause r))))

(defparameter *allow-debugger* nil)

(defun test-impl (name body-fn)
  (flet ((make-result (status &optional cause)
           (make-instance 'test-result :name name :status status :cause cause)))
    (handler-bind ((serious-condition
                    (lambda (c)
                      (unless *allow-debugger*
                        (format t "FAIL: ~A~%" c)
                        (return-from test-impl                          
                          (make-result :fail c))))))
      (format t "Running test ~S... " name)
      (funcall body-fn)
      (format t "OK~%")
      (make-result :ok))))

(defmacro test ((name) &body body)
  "If the BODY signals a SERIOUS-CONDITION
this macro returns a failed TEST-RESULT; otherwise
returns a successfull TEST-RESULT."
  `(test-impl (quote ,name) (lambda () ,@body)))


#|
  Used like this:

  (list (test (a) (assert (= 1 2)))
        (test (b) (assert (= 2 2)))
        (test (c) (assert (= 2 3))))

  => ;; list of test results, 2 failed 1 passed
     (#<TEST-RESULT A :FAIL Failed assertion: (= 1 2)> #<TEST-RESULT B :OK> #<TEST-RESULT C :FAIL Failed assertion: (= 2 3)>)

|#