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
(defun merge-list (list1 list2)
	(cond ((and (null list2) (null list1) ) nil) ;;if lists are null then return nil
	((null list1) list2);; if only one list then return it
	((null list2) list1 )
	(t (cons (car list1) (merge-list (cdr list1) list2) ) ;; add inputs recursively 
	
))
)


;; MAIN FUNCTION
(defun main ()
  (with-open-file (stream #p"input_part2.csv")
    (loop :for line := (read-csv-line stream) :while line :collect
      (format t "~a~%"
      (merge-list (read-from-string (nth 0 line)) (read-from-string (nth 1 line)))



      )
    )
  )
)

;; CALL MAIN FUNCTION
(main)
