(load "csv-parser.lisp")
(in-package :csv-parser)

;; (read-from-string STRING)
;; This function converts the input STRING to a lisp object.
;; In this code, I use this function to convert lists (in string format) from csv file to real lists.

;; (nth INDEX LIST)
;; This function allows us to access value at INDEX of LIST.
;; Example: (nth 0 '(a b c)) => a

;; !!! VERY VERY VERY IMPORTANT NOTE !!!
;; FOR EACH ARGUMENT IN CSV FILE
;; USE THE CODE (read-from-string (nth ARGUMENT-INDEX line))
;; Example: (mypart1-funct (read-from-string (nth 0 line)) (read-from-string (nth 1 line)))

;; DEFINE YOUR FUNCTION(S) HERE
(defun insert-n (list1 number index)
	(cond ((null list1) nil ) ;; check if the list is null then return nil
	((< index 0) nil) ;; if the given parameter index is not valid return nil 
	((= index 0) (append (list number) list1)) ;; if index is head of the list then firstly add the number then add given list basically
	(t (cons (car  list1)(insert-n (cdr  list1) number (- index 1)))) ;; recursive call to add elements one by one with decreasing index 

	)

)

;; MAIN FUNCTION
(defun main ()
  (with-open-file (stream #p"input_part3.csv")
    (loop :for line := (read-csv-line stream) :while line :collect
      (format t "~a~%"
      (insert-n (read-from-string(nth 0 line)) (read-from-string (nth 1 line)) (read-from-string (nth 2 line)))



      )
    )
  )
)

;; CALL MAIN FUNCTION
(main)
