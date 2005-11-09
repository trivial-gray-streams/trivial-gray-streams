(in-package :trivial-gray-streams)

(defclass trivial-gray-stream-mixin () ())

#+lispworks
(progn
  (defgeneric stream-read-sequence (stream sequence &optional start end))
  (defgeneric stream-write-sequence (stream sequence &optional start end))

  (defmethod stream:stream-read-sequence
      ((s trivial-gray-stream-mixin) seq start end)
    (stream-read-sequence seq start end))

  (defmethod stream:stream-write-sequence
      ((s trivial-gray-stream-mixin) seq start end)
    (stream-read-sequence seq start end)))

#+openmcl
(progn
  (defgeneric stream-read-sequence (stream sequence &optional start end))
  (defgeneric stream-write-sequence (stream sequence &optional start end))

  (defmethod ccl:stream-read-vector
      ((s trivial-gray-stream-mixin) seq start end)
    (stream-read-sequence seq start end))

  (defmethod ccl:stream-write-vector
      ((s trivial-gray-stream-mixin) seq start end)
    (stream-write-sequence seq start end)))

#+clisp
(progn
  (defgeneric stream-read-sequence (stream sequence &optional start end))
  (defgeneric stream-write-sequence (stream sequence &optional start end))

  (defmethod gray:stream-read-byte-sequence
      ((s trivial-gray-stream-mixin)
       seq
       &optional start end no-hang interactive)
    (when no-hang
      (error "this stream does not support the NO-HANG argument"))
    (when interactive
      (error "this stream does not support the INTERACTIVE argument"))
    (stream-read-sequence seq start end))

  (defmethod gray:stream-write-byte-sequence
      ((s trivial-gray-stream-mixin)
       seq
       &optional start end no-hang interactive)
    (when no-hang
      (error "this stream does not support the NO-HANG argument"))
    (when interactive
      (error "this stream does not support the INTERACTIVE argument"))
    (stream-write-sequence seq start end)))
