(in-package :snake)

(defclass game-menu-screen ()
  ((item
    :initarg :item
    :initform :play
    :accessor item)))

(defmethod draw-object ((obj game-menu-screen))
    (centered-text "SNAKE" :line -2 :font *header-font*)
    (centered-text "Menu" :line -2)
    (centered-text "Play" :line 0)
    (centered-text "Exit" :line 1)
    (case (item obj)
      (:play (centered-text "Play" :line 0 :font *selected-font*))
      (:exit (centered-text "Exit" :line 1 :font *selected-font*))))

(defmethod catch-key ((obj game-menu-screen) key)
    (cond
      ((eql key :scancode-e)
       (case (item obj)
         (:play (set-screen :game))
         (:exit (close-window))))
      ((or (eql key :scancode-w) (eql key :scancode-s))
       (with-slots (item) obj
           (setf item (case item
                        (:exit :play)
                        (:play :exit)))))))
