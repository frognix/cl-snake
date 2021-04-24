(in-package :snake)

(defparameter *field* nil)
(defparameter *break-snake-loop* nil)

(defclass food (cell) ())

(defclass game-field-screen ()
  ((height
    :initarg :height
    :accessor height)
   (width
    :initarg :width
    :accessor width)
   (snake
    :initarg :snake
    :accessor snake)
   (snake-thread
    :initform nil
    :accessor snake-thread)
   (food
    :initform ()
    :initarg :food
    :accessor food)))

(defun create-default-field ()
    (make-instance 'game-field-screen
                   :width +cell-count+
                   :height +cell-count+
                   :snake (make-instance 'snake :body (list (snake-cell 1 1) (snake-cell 2 1) (snake-cell 3 1))
                                                :direction :left)
                   :food (list (make-instance 'food :x 5 :y 5))))

(defun cell-near (cell dir)
    (declare (cell cell))
    (let ((x (x cell)) (y (y cell)))
        (with-slots (height width food snake) *field*
            (case dir
              (:left (decf x))
              (:right (incf x))
              (:up (decf y))
              (:down (incf y)))
            (let ((cell (make-instance 'cell
                                       :x (abs (mod x width))
                                       :y (abs (mod y height)))))
                (or (find cell food :test #'cell-equal)
                    (find cell (body snake) :test #'cell-equal)
                    cell)))))

(defun add-food ()
    (with-slots (width height food snake) *field*
        (let ((food-cell (make-instance 'food
                                        :x (random width)
                                        :y (random height))))
            (if (find food-cell (body snake) :test #'cell-equal)
                (add-food)
                (setf food (cons food-cell food))))))

(defun drop-last (list)
    (reverse (cdr (reverse list))))

(defgeneric collide (first second)
    (:documentation "Action after collision of objects on field"))

(defmethod collide ((snake-cell snake-cell) (food-cell food))
    (with-slots (height width snake food) *field*
        (setf food (remove food-cell food :test #'cell-equal))
        (add-food)
        (incf (score snake))
        (setf (body snake) (cons (snake-cell-from-cell food-cell) (body snake)))))

(defmethod collide ((snake-cell snake-cell) (another-snake snake-cell))
    (game-over-screen)
    (funcall *break-snake-loop*))

(defmethod collide ((snake-cell snake-cell) (cell cell))
    (with-slots (body) (snake *field*)
        (setf body (cons (snake-cell-from-cell cell) (drop-last body)))))

(defun snake-move ()
    (with-slots (width height snake food) *field*
        (with-slots (body direction) snake
            (collide (car body) (cell-near (car body) direction)))))

(defun field-step ()
    (when (= (random 10) 0) (add-food))
    (snake-move))

(defun snake-loop ()
    (loop
      (sleep (+ 0.1 (/ 0.2 (log (+ 3 (score (snake *field*)))))))
      (let ((*break-snake-loop* (lambda () (return))))
          (field-step))))

(defun create-snake-thread (game)
    (setf (snake-thread game)
          (bordeaux-threads:make-thread #'snake-loop :name "Snake main loop")))

(defun destroy-snake-thread (game)
    (when (snake-thread game)
        (setf (snake-thread game) nil)))

(defmethod draw-object ((obj food))
    (draw-cell obj +green+))

(defun draw-grid (height width n)
    (declare (fixnum height width n))
    (let ((step (/ height n)))
        (dotimes (i n)
            (line 0 (* step i) width (* step i))
            (line (* step i) 0 (* step i) height))))

(defmethod draw-object ((obj game-field-screen))
    (with-slots (height width snake food) obj
        (loop for f in food do (draw-object f))
        (draw-object snake)
        (draw-grid (* height +cell-size+) (* width +cell-size+) +cell-count+)))

(defun set-direction (dir)
    (unless (or (equal dir (opposite-direction (direction (snake *field*))))
                (not dir))
        (setf (direction (snake *field*)) dir)))

(defmethod catch-key ((obj game-field-screen) key)
    (block set
        (set-direction (case key
                         (:scancode-a :left)
                         (:scancode-d :right)
                         (:scancode-w :up)
                         (:scancode-s :down)
                         (:scancode-q
                          (bordeaux-threads:destroy-thread (snake-thread *field*))
                          (set-screen :menu)
                          (return-from set))))))
