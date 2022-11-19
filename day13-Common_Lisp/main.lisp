; Could be much nicer
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
    (part2 scanners)
  )
)

(defun part1 (scanners) 
  (let ((severity (delay-severity scanners 0)))
    (format t "Cost of going immediately: ~A~%" severity)
  ) 
)

; Got really annoyed that they removed severyty and now only cared
; about getting caught (range 0 now important). Thefore I had to
; trick my other things by increasing all scanners ranges by 1. We 
; know 0 delay won't work, so we can increase range and still start
; at 0 (which is the same as starting on one).
(defun part2 (scanners)
  (let* ((further-scanners (mapcar 
           #'(lambda (scanner) 
             (make-instance 'scanner 
               :range (+ 1 (range scanner)) 
               :depth (depth scanner)))
           scanners))
         (delay 0)
         (severity 1)); Dummy value to enter for loop
    (loop while (> severity 0) do
      (setq severity (delay-severity further-scanners delay))
      (setq delay (+ 1 delay))
    )
    (format t "First perfect delay: ~A~%" delay)
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

(main)
