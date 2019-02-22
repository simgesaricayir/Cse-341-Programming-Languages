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
(defun list-leveller (lst)
(cond ((null lst) nil) ;; if the list null return nil
((equal lst 'QUOTE)nil) 
( (atom lst) (list lst));; if it is atom cast it list
(t (append (list-leveller (car lst)) (list-leveller (cdr lst)))))) ;; add items with recursively


;; MAIN FUNCTION
(defun main ()
  (with-open-file (stream #p"input_part1.csv")
    (loop :for line := (read-csv-line stream) :while line :collect
      (format t "~a~%"
      (list-leveller (read-from-string (nth 0 line)))



      )
    )
  )
)

;; CALL MAIN FUNCTION
(main)
