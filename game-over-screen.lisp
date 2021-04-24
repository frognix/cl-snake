(in-package :snake)

(defclass game-over-screen () ())

(defparameter *end-score* 0)

(defun game-over-screen ()
    (setf *end-score* (score (snake *current-screen*)))
    (set-screen :game-over))

(defmethod draw-object ((obj game-over-screen))
    (centered-text "Game over" :line -1)
    (centered-text (format nil "Your score is: ~a" (* *end-score* 100)))
    (centered-text "Press any key to return to menu" :line 1))

(defmethod catch-key ((obj game-over-screen) key)
    (set-screen :menu))
