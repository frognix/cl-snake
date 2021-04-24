(in-package :snake)

(defparameter *screens* (list
                         :menu (make-instance 'game-menu-screen)
                         :game (create-default-field)
                         :game-over (make-instance 'game-over-screen)))

(defun set-screen (key)
    (when (eq *current-screen* (getf *screens* :game))
        (destroy-snake-thread *current-screen*)
        (setf (getf *screens* :game) (create-default-field)))
    (setf *current-screen*
          (case key
            (:menu (getf *screens* :menu))
            (:game
             (setf *field* (getf *screens* :game))
             (create-snake-thread *field*)
             *field*)
            (:game-over (getf *screens* :game-over)))))

(defun start-snake ()
    (set-screen :menu)
    (setf *window* (make-instance 'snake-window)))
