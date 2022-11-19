(defclass scanner () 
  ((range
    :initarg :range
    :accessor range)
  (depth
    :initarg :depth
    :accessor depth))); Could type annotate as unsigned ints

(defun main () 
  (let* ((scanners (parse)))
    (part1 scanners) 
  )
)

(defun part1 (scanners) 
  (let ((severity (delay-severity scanners 0)))
    (format t "Cost of going immediately: ~A~%" severity)
  ) 
)
 
(defun delay-severity (scanners delay)
  (apply '+ 
    (mapcar 
      #'(lambda (scanner) (scanner-severity scanner delay)) 
      scanners
    )
  )
)

(defun scanner-severity (scanner delay)
  (let* ((steps (+ (range scanner) delay))
         (cycle-steps (* 2 (- (depth scanner) 1))) 
         (scanner-pos (mod steps cycle-steps)))
    (if (= 0 scanner-pos)
      (* (depth scanner) (range scanner))
      0    
    )
  )
)

; Would probably be better to read the whole input and then split & map.
(defun parse () 
  (let ((line (read-line nil nil)))
    (if line 
      (let ((scanner (parse-line line))); Add another value
        (cons scanner (parse))
      )
      nil; Done, just return empty
    )
  )
)

(defun parse-line (line)
  (let* ((split-pos (position #\: line)); let* does bindings sequentially
         (range (parse-integer line :start 0 :end split-pos))
         (depth (parse-integer line :start (+ 2 split-pos) :end (length line))))
  (make-instance 'scanner :range range :depth depth))
)

;(setq f1 (make-instance 'scanner :range 1 :depth 2))
;(setq f3 (make-instance 'scanner :range 6 :depth 4))

(main)
