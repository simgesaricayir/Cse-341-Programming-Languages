(defconstant LETTER 0);;define constant type for letter
(defconstant DIGIT 1);; define constant type for digit
(defconstant UNKNOWN 99);;define unknown for operators and unknown charachters

(setq varlist '() );;list that return the tokens in the file
(setq charClass 0);;charlass variable to classification the given charachter 
(setq index 0) ;; index variable to check index and proceed into the reading string from the file
(setq str "") ;; str variable to hold string which is read from the file
(setq token "") ;; token variable to adding token after found it 
(setq flag 0) ;; flag for finding operator or unknown it is for check exactly

(defun get-file (filename);;function for reading the file line by line and concatenate them into the str file.
 (with-open-file (stream filename)
    (do ((line (read-line stream nil)
               (read-line stream nil)))
        ((null line))
      (setq str( concatenate 'string str line));; set every line after the concataenate them 
    )
  )
)


(defun getchar(ch);; find the ch's group. alpha char or unknown
	(cond 
      	((alpha-char-p ch) (setq charClass LETTER));; if the given charachter is char so it's class is constant LETTER
      	((digit-char-p ch) (setq charClass DIGIT));; if the given charachter is digit so it's class is constant DIGIT
      	((and (not (alpha-char-p ch)) (not (digit-char-p ch))  )  (setq charClass UNKNOWN))
      	;; if the charachter is not char or digit then it is operator or unknown charachter so make it class is UNKNOWN
    )
(lex);;After classification call the lex function to call the right function for dfa step

)

(defun lex()
	(cond 
      	( (equal charClass LETTER);;if the current charClass is letter then call dfa step for letter
      	  (dfa_letter)
      	)
      	(
      	  (equal charClass DIGIT);;if the current charClass is digit then call dfa step for digit
      	  (dfa_digit)
      	)
      	(
      	  (equal charClass UNKNOWN);;if the current charClass is unknown then call dfa step for unknown character
      	  (dfa_unknown)
      	)
    )

)

(defun dfa_letter()
(setq flag 0)
(setq temp '());; temp variable for adding token and it's lexeme 
(setq text "keyword");;token's lexeme group
;; loop for finding the token while the character is alpha then concatanete them every loop 
(loop while (and (< index (length str))(alpha-char-p  (send_with_index index) ))do
      (setq token( concatenate 'string token (string(send_with_index index))))
      (setq index (+ 1 index));; increase the index for specify the proceed the right index
 )
(cond 
	((equal token "and")  (setq flag 1));; if the token is and set flag 1 to indicate it is a keyword.
	((equal token "or") (setq flag 1));;Do it same operation other keywords
	((equal token "not")  (setq flag 1))
	((equal token "equal")  (setq flag 1))
	((equal token "append")  (setq flag 1))
	((equal token "set") (setq flag 1))
	((equal token "deffun")  (setq flag 1))
	((equal token "for") (setq flag 1))
	((equal token "while") (setq flag 1))
	((equal token "if") (setq flag 1))
	((equal token "exit") (setq flag 1))
	((equal flag 0) (setq text "identifier"));; if the token is letter and also it is not a keyword then it is a identifier
	
)
(setq temp(append temp (list text)));; append the token's lexeme before the adding token 
(setq temp(append temp (list token)));; add token the same list
(setq varlist(append varlist (list temp)));; add the new token and it's lexeme to varlist to return afterwards
(setq token "");; set the token null for other functions
(if (< index (length str));; if index is not exceeded continue with the next character in the str 
  (getchar (send_with_index index)))
)

(defun dfa_digit()
(setq temp '())
;; loop for finding the token while the character is digit then concatanete them every loop 
(loop while (and (< index (length str))(digit-char-p (send_with_index index) ))do
 	(setq token( concatenate 'string token (string(send_with_index index))))
	(setq index (+ 1 index))
)
  (setq text "integer");;set text to token's lexeme is integer
  (setq temp(append temp (list text)));; append text to temp list to verify the lexeme
  (setq temp(append temp (list token)));; then add the token the same list
  (setq varlist(append varlist (list temp)));; append the temp list to varlist 
  (setq token "")
  (if (< index (length str));; if index is not exceeded continue with the next character in the str 
  (getchar (send_with_index index)))
)


(defun dfa_unknown()
;; set the token with send with index function
(setq token( concatenate 'string token (string(send_with_index index))))

;;condition for the square operator because it is a special case.Only one operator is inclued two operator side-by-side
(cond
((equal token "*") (setq token( concatenate 'string token (string(send_with_index (+ 1 index))))))
 ((equal token "**") (setq index (+ 1 index)))
)

(setq temp '() )
(setq text "operator");; set text variable to token's lexeme is operator
(setq unkn "unknown token!");; set unknown token warning when the unrecognized token is find
(setq flag 0)
(setq blank 0) ;; set blank variable to zero to use it ignore the blank

(cond
;; if the token is paranthess set temp to add varlist 
((equal token "(") (setq temp(append temp (list text)))(setq temp(append temp (list token))) (setq flag 1) )
((equal token ")") (setq temp(append temp (list text)))(setq temp(append temp (list token)))(setq flag 1))
((equal token " ")(setq blank 1));; if it is blank mark the blank variable one
)
(setq index (+ 1 index));; because of the token is found take formard the index
;; loop for finding the unkown token 
(loop while (and (equal blank 0)(equal flag 0)(< index (length str))(or(digit-char-p (send_with_index index))
  (alpha-char-p(send_with_index index))))do
  (setq token( concatenate 'string token (string(send_with_index index))))
  (setq index (+ 1 index))
)

(cond
((equal token "+") (setq temp(append temp (list text)))(setq temp(append temp (list token)))(setq flag 1))
((equal token "-") (setq temp(append temp (list text)))(setq temp(append temp (list token)))(setq flag 1))
((equal token "*") (setq temp(append temp (list text)))(setq temp(append temp (list token)))(setq flag 1))
((equal token "/") (setq temp(append temp (list text)))(setq temp(append temp (list token)))(setq flag 1))
((equal token "**") (setq temp(append temp (list text)))(setq temp(append temp (list token)))(setq flag 1))
((and(equal flag 0)(not(equal token " "))) (setq temp(append temp (list unkn)))(setq temp(append temp (list token)))(setq flag 1))
)

(if(equal flag 1)(setq varlist(append varlist (list temp))))
(setq token "")
(if (< index (length str))
  (getchar (send_with_index index)))
)


(defun send_with_index (i);;send the character in the str with the given index
(if (< i (length str))
    (char str i)))
     
(defun lexer(fileName);; lexer function that starts the process
(get-file fileName);; read file and set the string variable str 
(getchar (send_with_index index));;call the getchar function the start the dfa 
(return-from lexer varlist);; after all return the list that contains the token's and lexemes
)



