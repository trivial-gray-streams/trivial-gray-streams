(in-package :trivial-gray-streams)

(defclass trivial-gray-stream-mixin () ())

(defgeneric stream-read-sequence
    (stream sequence start end &key &allow-other-keys))
(defgeneric stream-write-sequence
    (stream sequence start end &key &allow-other-keys))

(defmethod stream-write-string
    ((stream trivial-gray-stream-mixin) seq &optional start end)
  (stream-write-sequence stream seq (or start 0) (or end (length seq))))

#+allegro
(progn
  (defmethod excl:stream-read-sequence
      ((s trivial-gray-stream-mixin) seq &optional start end)
    (stream-read-sequence s seq (or start 0) (or end (length seq))))
  (defmethod stream:stream-write-sequence
      ((s trivial-gray-stream-mixin) seq &optional start end)
    (stream-write-sequence s seq (or start 0) (or end (length seq)))))

#+cmu
(progn
  (defmethod ext:stream-read-sequence
      ((s trivial-gray-stream-mixin) seq &optional start end)
    (stream-read-sequence s seq (or start 0) (or end (length seq))))
  (defmethod ext:stream-write-sequence
      ((s trivial-gray-stream-mixin) seq &optional start end)
    (stream-write-sequence s seq (or start 0) (or end (length seq)))))

#+lispworks
(progn
  (defmethod stream:stream-read-sequence
      ((s trivial-gray-stream-mixin) seq start end)
    (stream-read-sequence s seq start end))

  (defmethod stream:stream-write-sequence
      ((s trivial-gray-stream-mixin) seq start end)
    (stream-write-sequence s seq start end)))

#+openmcl
(progn
  (defmethod ccl:stream-read-vector
      ((s trivial-gray-stream-mixin) seq start end)
    (stream-read-sequence s seq start end))

  (defmethod ccl:stream-write-vector
      ((s trivial-gray-stream-mixin) seq start end)
    (stream-write-sequence s seq start end)))

#+clisp
(progn
  (defmethod gray:stream-read-byte-sequence
      ((s trivial-gray-stream-mixin)
       seq
       &optional start end no-hang interactive)
    (when no-hang
      (error "this stream does not support the NO-HANG argument"))
    (when interactive
      (error "this stream does not support the INTERACTIVE argument"))
    (stream-read-sequence s seq start end))

  (defmethod gray:stream-write-byte-sequence
      ((s trivial-gray-stream-mixin)
       seq
       &optional start end no-hang interactive)
    (when no-hang
      (error "this stream does not support the NO-HANG argument"))
    (when interactive
      (error "this stream does not support the INTERACTIVE argument"))
    (stream-write-sequence s seq start end))

  (defmethod gray:stream-read-char-sequence
      ((s trivial-gray-stream-mixin) seq &optional start end)
    (stream-read-sequence s seq start end))

  (defmethod gray:stream-write-char-sequence
      ((s trivial-gray-stream-mixin) seq &optional start end)
    (stream-write-sequence s seq start end)))

#+sbcl
(progn
  (defmethod sb-gray:stream-read-sequence
      ((s trivial-gray-stream-mixin) seq &optional start end)
    (stream-read-sequence s seq (or start 0) (or end (length seq))))
  (defmethod sb-gray:stream-write-sequence
      ((s trivial-gray-stream-mixin) seq &optional start end)
    (stream-write-sequence s seq (or start 0) (or end (length seq))))
  ;; SBCL extension:
  (defmethod sb-gray:stream-line-length ((stream trivial-gray-stream-mixin))
    80)
  ;; SBCL should provide this default method, but doesn't?
  (defmethod stream-terpri ((stream trivial-gray-stream-mixin))
    (write-char #\newline stream)))
