(in-package :snake)

(defclass snake-cell (cell) ())

(defun snake-cell (x y)
    (declare (fixnum x y))
    (make-instance 'snake-cell :x x :y y))

(defun snake-cell-from-cell (cell)
    (declare (cell cell))
    (with-slots (x y) cell (snake-cell x y)))

(defmethod draw-object ((obj snake-cell))
    (draw-cell obj +red+))

(defclass snake ()
  ((body
    :initarg :body
    :accessor body)
   (direction
    :initarg :direction
    :accessor direction)
   (score
    :initform 0
    :initarg :score
    :accessor score)))

(defun opposite-direction (dir)
    (case dir
      (:left :right)
      (:right :left)
      (:up :down)
      (:down :up)))

(defmethod draw-object ((obj snake))
    (loop for c in (body obj) do (draw-object c)))
