(load "csv-parser.lisp")
(in-package :csv-parser)

;; (read-from-string STRING)
;; This function converts the input STRING to a lisp object.
;; In this code, I use this function to convert lists (in string format) from csv file to real lists.

;; (nth INDEX LIST)
;; This function allows us to access value at INDEX of LIST.
;; Example: (nth 0 '(a b c)) => a

;; !!! VERY VERY VERY IMPORTANT NOTE !!!
;; To access each argument in csv file
;; use this code (read-from-string (nth ARGUMENT-INDEX line))
;; Example: (mypart1-funct (read-from-string (nth 0 line)) (read-from-string (nth 1 line)))

;; To see the result on Ubuntu
;; Open the terminal within folder
;; type the command below
;; clisp working_example.lisp > out.txt

;; DEFINE YOUR FUNCTION(S) HERE
(defun merge-lists (listA listB)
  (append listA listB)
)

;; MAIN FUNCTION
(defun main ()
  (with-open-file (stream #p"input_part1.csv")
    (loop :for line := (read-csv-line stream) :while line :collect
      (format t "~a~%"
      ;; CALL YOUR (MAIN) FUNCTION HERE
        (merge-lists (read-from-string (nth 0 line)) (read-from-string (nth 1 line)))
      )
    )
  )
)

;; CALL MAIN FUNCTION
(main)
