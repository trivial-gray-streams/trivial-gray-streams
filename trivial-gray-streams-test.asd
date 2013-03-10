;;; -*- mode: lisp -*-

(defsystem :trivial-gray-streams-test
  :version "2.0"
  :serial t
  :depends-on (:trivial-gray-streams)
  :components ((:file "test-framework") (:file "test")))
