(in-package :snake)

(defclass game-over () ())

(defparameter *end-score* 0)

(defun game-over ()
    (setf *end-score* (score (snake *current-screen*)))
    (set-screen :game-over))

(defmethod draw-object ((obj game-over))
    (centered-text "Game over" :line -1)
    (centered-text (format nil "Your score is: ~a" (* *end-score* 100)))
    (centered-text "Press any key to return to menu" :line 1))

(defmethod catch-key ((obj game-over) key)
    (set-screen :menu))
