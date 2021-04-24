(in-package :snake)

(defclass cell ()
  ((x
    :initarg :x
    :accessor x)
   (y
    :initarg :y
    :accessor y)))

(defmethod print-object ((c cell) s)
    (format s "(~a,~a)" (x c) (y c)))

(defun cell (x y)
    (declare (fixnum x y))
    (make-instance 'cell :x x :y y))

(defun cell-equal (cell1 cell2)
    (declare (cell cell1 cell2))
    (with-slots ((x1 x) (y1 y)) cell1
        (with-slots ((x2 x) (y2 y)) cell2
            (and (= x1 x2) (= y1 y2)))))

(defun draw-cell (cell color)
    (with-slots (x y) cell
        (with-pen (make-pen :fill color)
            (rect (* x +cell-size+) (* y +cell-size+)
                  +cell-size+ +cell-size+))))
