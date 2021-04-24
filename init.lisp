(in-package :snake)

(defparameter *default-font* nil)
(defparameter *selected-font* nil)
(defparameter *header-font* nil)

(defparameter *initialization-stage* t)
(defsketch snake-window ((height +window-height+) (width +window-width+))
    (when *initialization-stage*
        (setf *default-font* (make-default-font :color +green+ :size 18))
        (setf *selected-font* (make-default-font :color +red+ :size 18))
        (setf *header-font* (make-default-font :color +green+ :size 54))
        (set-font *default-font*)
        (setf *initialization-stage* nil))
    (background +white+)
    (draw-object *current-screen*))

(defun close-window ()
    (sdl2.kit:close-window *window*))

(defmethod kit.sdl2:keyboard-event ((window snake-window) state
                                    timestamp repeat-p keysym)
    (when (eql state :keydown)
        (catch-key *current-screen* (sdl2:scancode keysym))))

(defgeneric draw-object (obj)
    (:documentation "Draw object in sketch context"))

(defgeneric catch-key (obj key)
    (:documentation "Run actions on pressed keys"))
