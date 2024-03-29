;;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-lisp; -*-

(defsystem :trivial-gray-streams
  :description "Compatibility layer for Gray Streams (see http://www.cliki.net/Gray%20streams)."
  :license "MIT"
  :author "David Lichteblau"
  :maintainer "Anton Vodonosov <avodonosov@yandex.ru>"
  :version "2.1"
  :serial t
  :components ((:file "package") (:file "streams")))
