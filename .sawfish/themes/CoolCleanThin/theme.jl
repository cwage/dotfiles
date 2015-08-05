
(require 'gradient)

(defgroup CoolCleanThin "CoolCleanThin Settings" 
  :group appearance)

(defcustom CoolCleanThin:gradient-type 'diagonal
  "Direction of gradient."
  :type (set horizontal vertical diagonal)
  :group (appearance CoolCleanThin)
  :after-set after-setting-frame-option)

(defcustom CoolCleanThin:solid-colors nil
  "Use solid colors instead of gradients (Uses `From' colors)."
  :group (appearance CoolCleanThin)
  :type boolean
  :after-set after-setting-frame-option)

(defcustom CoolCleanThin:normal-from-color(get-color "#8d8d8d")
  "`From' color of inactive frames."
  :type color
  :group (appearance CoolCleanThin)
  :after-set after-setting-frame-option)

(defcustom CoolCleanThin:normal-to-color (get-color "#bcbcbc")
  "`To' color of inactive frames."
  :type color
  :group (appearance CoolCleanThin)
  :after-set after-setting-frame-option)

(defcustom CoolCleanThin:active-from-color (get-color "#000099")
  "`From' color of active frames."
  :type color
  :group (appearance CoolCleanThin)
  :after-set after-setting-frame-option)

(defcustom CoolCleanThin:active-to-color (get-color "#5588aa")
  "`To' color of active frames."
  :type color
  :group (appearance CoolCleanThin)
  :after-set after-setting-frame-option)

(defcustom CoolCleanThin:normal-text-color (get-color "#333333")
  "Title text color of inactive frames."
  :type color
  :group (appearance CoolCleanThin)
  :after-set after-setting-frame-option)

(defcustom CoolCleanThin:active-text-color (get-color "#FFFFFF")
  "Title text color of active frames."
  :type color
  :group (appearance CoolCleanThin)
  :after-set after-setting-frame-option)

;; The font
;;(defcustom CoolCleanThin:font 
;;  (get-font "-adobe-helvetica-medium-r-normal-*-*-100-*-*-*-*-*-*")
;;  "Font for window titles."
;;  :type font
;;  :group (appearance CoolCleanThin)
;;  :after-set after-setting-frame-option)



(let*
;; images
;; The standard images
;; 2x6
((bottom-images (make-image "bottom.png"))


;; 3x22
(top-right-images (make-image "top_right.png"))
(s-top-right-images (make-image "s_top_right.png"))

;; 53x22
(top-right-button-box-images (make-image "top_right_button_box.png"))
(s-top-right-button-box-images (make-image "s_top_right_button_box.png"))

;; 25x25
(bottom-left-images (make-image "bottom_left.png"))

;; 25x25
(bottom-right-images (make-image "bottom_right.png"))

;; 16x16
(close-images (list (make-image "close_normal.png")
				    nil nil
				    (make-image "close_clicked.png")))

;; 16x16
(maximize-images (list (make-image "maximize_normal.png")
				       nil nil
				       (make-image "maximize_clicked.png")))

;; 16x16
(iconify-images (list (make-image "minimize_normal.png")
				      nil nil
				      (make-image "minimize_clicked.png")))

;; 22x22
(menu-images (make-image "menu.png"))
(s-menu-images (make-image "s_menu.png"))

;; 6x19
(left-images (make-image "left.png"))

;; 6x19
(right-images (make-image "right.png"))



(render-bg (lambda (img state)
  (apply (cond ((eq CoolCleanThin:gradient-type 'diagonal)
        draw-diagonal-gradient)
           ((eq CoolCleanThin:gradient-type 'horizontal)
        draw-horizontal-gradient)
           ((eq CoolCleanThin:gradient-type 'vertical)
        draw-vertical-gradient))
         img (if (or (eq state 'focused)
                     (eq state 'highlighted)
	             (eq state 'clicked))
                 (list CoolCleanThin:active-from-color (if CoolCleanThin:solid-colors CoolCleanThin:active-from-color CoolCleanThin:active-to-color))
               (list CoolCleanThin:normal-from-color (if CoolCleanThin:solid-colors CoolCleanThin:normal-from-color CoolCleanThin:normal-to-color))))
  (when (> (cdr (image-dimensions img)) 4)
    (bevel-image img 1 1))
  (set-image-border img 1 1 1 1)))


;; frame layout
(frame
  `(
    ;; title bar image
    ((background . "black")
     (top-edge . -14)
     (left-edge . 10)
     (right-edge . 37)
	 (height . 14)
     (class . top-border))

 ;; title bar
    ((renderer . ,render-bg)
     (foreground . ,(lambda () (list CoolCleanThin:normal-text-color CoolCleanThin:active-text-color)))
	 (font . ,(lambda () (list CoolCleanThin:font)))
     (text . ,window-name)
     (x-justify . 4)
     (y-justify . center)
     (top-edge . -13)
	 (height . 12)
     (left-edge . 10)
     (right-edge . 37)
     (class . title))

    ;; menu button
    ((background . ,menu-images)
     (top-edge . -14)
     (left-edge . -4)
     (class . menu-button))

    ;; left border
    ((background . ,left-images)
     (left-edge . -4)
     (top-edge . 0)
     (bottom-edge . 19)
     (class . left-border))

    ;; top-right corner
    ((background . ,top-right-images)
     (right-edge . -4)
     (top-edge . -14)
     (class . top-right-corner))

    ;; top-right-button-box corner
    ((background . ,top-right-button-box-images)
     (right-edge . -2)
     (top-edge . -14)
     (class . title))

    ;; right border
    ((background . ,right-images)
     (right-edge . -4)
     (top-edge . 0)
     (bottom-edge . 0)
     (class . right-border))

    ;; bottom border
    ((background . ,bottom-images)
     (left-edge . 17)
     (right-edge . 19)
     (bottom-edge . -4)
     (class . bottom-border))

    ;; bottom-left corner
    ((background . ,bottom-left-images)
     (left-edge . -4)
     (bottom-edge . -4)
     (class . bottom-left-corner))

    ;; bottom-right corner
    ((background . ,bottom-right-images)
     (right-edge . -4)
     (bottom-edge . -4)
     (class . bottom-right-corner))

    ;; iconify button
    ((background . ,iconify-images)
     (right-edge . 25)
     (top-edge . -12)
     (class . iconify-button))

    ;; maximize button
    ((background . ,maximize-images)
     (right-edge . 12)
     (top-edge . -12)
     (class . maximize-button))

    ;; delete button
    ((background . ,close-images)
     (right-edge . 0)
     (top-edge . -12)
     (class . close-button))))

;; shaped frame layout
(shaped-frame
  `(
    ;; title bar image
    ((background . "black")
     (top-edge . -14)
     (left-edge . 10)
     (right-edge . 37)
	 (height . 14)
     (class . top-border))

 ;; title bar
    ((renderer . ,render-bg)
     (foreground . ,(lambda () (list CoolCleanThin:normal-text-color CoolCleanThin:active-text-color)))
	 (font . ,(lambda () (list CoolCleanThin:font)))
     (text . ,window-name)
     (x-justify . 4)
     (y-justify . center)
     (top-edge . -13)
	 (height . 12)
     (left-edge . 10)
     (right-edge . 37)
     (class . title))

    ;; menu button
    ((background . ,s-menu-images)
     (top-edge . -14)
     (left-edge . -4)
     (class . menu-button))

    ;; top-right corner
    ((background . ,s-top-right-images)
     (right-edge . -4)
     (top-edge . -14)
     (class . top-right-corner))

    ;; top-right-button-box corner
    ((background . ,s-top-right-button-box-images)
     (right-edge . -2)
     (top-edge . -14)
     (class . title))

    ;; iconify button
    ((background . ,iconify-images)
     (right-edge . 25)
     (top-edge . -12)
     (class . iconify-button))

    ;; maximize button
    ((background . ,maximize-images)
     (right-edge . 12)
     (top-edge . -12)
     (class . maximize-button))

    ;; delete button
    ((background . ,close-images)
     (right-edge . 0)
     (top-edge . -12)
     (class . close-button))))
)


;; Frame definition
; note we decorate transients the same as non-transients
(add-frame-style 'CoolCleanThin
		 (lambda (w type)
		   (case type
			 ((default) frame)
			 ((transient) frame)
			 ((shaped) shaped-frame)
			 ((shaped-transient) shaped-frame)))))
