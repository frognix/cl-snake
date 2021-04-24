(defpackage :snake
  (:use :cl :sketch :sketch-misc)
  (:export start-snake +default-field+))
(in-package :snake)

(defconstant +window-width+ 756)
(defconstant +window-height+ 756)
(defconstant +cell-count+ 15)
(defconstant +cell-size+ (/ +window-width+ +cell-count+))

(defparameter *current-screen* nil)
(defparameter *window* nil)

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
    (let ((*window-width* +window-width+) (*window-height* +window-height+))
        (draw-object *current-screen*)))

(defun close-window ()
    (sdl2.kit:close-window *window*)
    (cl-user::quit))

(defmethod kit.sdl2:keyboard-event ((window snake-window) state
                                    timestamp repeat-p keysym)
    (when (eql state :keydown)
        (catch-key *current-screen* (sdl2:scancode keysym))))

(defgeneric draw-object (obj)
    (:documentation "Draw object in sketch context"))

(defgeneric catch-key (obj key)
    (:documentation "Run actions on pressed keys"))
