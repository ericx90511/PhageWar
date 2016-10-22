;  .=================================================================. 
;  :*-------*       *       *       *-------*       *       *       *:  
;  :| C1:+5 |                       | C2:+3 |                        :  
;  :| P1:15 |                       | P1:05 |                        :  
;  :*-------*       *       *       *-------*       *       *       *:  
;  :                                                                 :  
;  :                                                                 :  
;  :*       *       *       *---------------*       *       *       *:  
;  :                        |PhageWars++.scm|                        :  
;  :                        |CSCI 1901 F2013|                        :  
;  :*       *       *       *---------------*       *       *       *:  
;  :                                                                 :  
;  :                                                                 :  
;  :*       *       *       *-------*       *       *       *-------*:  
;  :                        | C3:+3 | 10:C3                 | C4:+5 |:  
;  :                        |  N:0  |   P2                  | P2:10 |:  
;  :*       *       *       *-------*       *       *       *-------*:  
;  `=================================================================` 
;  .=Queue===========================================================. 
;  :  10:C3 :                                                        :
;  :  P2:01 :                                                        :
;  `=Enrage: 1.1===========================================Turn: 11==' 



;;;;;;;;;;;;;;;;;;;;;;;
;;;DEFINED CONSTANTS;;;
;;;;;;;;;;;;;;;;;;;;;;;

;; Version of this code:
(define *SOURCE-REVISION* 12)

;; Board dimensions - minimum three in each direction.  Assigned by map.
(define *NUM-ROWS* 6)
(define *NUM-COLUMNS* 6)

;; Movement speed for attacks.  This is a place-holder variable.  It is 
;; reassigned when the map is loaded.
(define *MOVE-SPEED* 3)

;; Number of cells on the board, reassigned when a map is loaded.
(define *NUM-CELLS* 3)

;; Max unit count per cell
;; This value should be no more than 999, because there is no room for four 
;; digits to be displayed 200 is default, could be changed but will not vary 
;; between maps. Changes will be mentioned in lab OR on the website if made to 
;; this value.
(define *MAX-UNITS* 200)

;; Current Turn Number
(define *CURRENT-TURN* 1)

;; Enrage Values
;; Default values provide (* 1.0 units) on an attack in the first 10 turns, and
;; on turn 10, attacks become (* 1.1 units). Remaining units are still half the 
;; original unit-count of the cell.
(define *ENRAGE-VALUE-INITIAL* 1.0)
(define *ENRAGE-TURN-INCREMENT* 10)
(define *ENRAGE-INCREMENT* .1)

;; Defender bonus
;; The amount of extra units a cell gets when it does not send units to another cell.
;; Default value is 2, this can (but should not) change between maps.
(define *DEFENDER-BONUS* 2)

;; Delay settings
(define *SLEEP-MILLISECONDS* 750) ;; Time to pause between moves
(define *STALL* #t)               ;; Prompt to continue?

;; Safe Player Execution?
;; If #t, this will suppress error messages when a player procedure crashes.
;; DO NOT USE THIS WHILE TESTING YOUR CODE!  DO NOT USE THIS WHILE TESTING YOUR CODE!
(define *SAFE-PLAYER-EXECUTION* #f)

;; Map Selection Mode
;;  Remove the comment from the mode you would like
;;	If 'specific, uncomment the appropriate map below
(define *MAP-SELECTION-MODE*
        'random
	;'specific
	)
;;Uncomment one of the premade maps, or add your own.  Leave only one tag uncommented!
(define *SPECIFIC-MAP* 
	;'map1
	'map2
	;'map3
	;'map4
	;'map5
	;'map6
	;'map7
)
	
	

;;The value for the limit is a map variable, mostly based on cell count.
;;Assume the time limit is the default value in most cases.
;;Leave *TIME-LIMIT-ON?* as false, it will change final-game return values.
(define *TIME-LIMIT-ON?* #t)
(define *AI-TIME-LIMIT* 2)
	
;; Max Turns before the game ends in a tie. Only checked when *TIME-LIMIT-ON?* is #t
(define *MAX-TURNS* 1000)

;; Tester printouts?  This will slow display times and grossly clutter the display.
;; Intended for development purposes only.  Don't worry about this variable.
(define tests #f)

;; Display moves on the board?
(define *DISPLAY-MOVES-ON-BOARD* #t)

;; Determines if the output is colored.  Only use this to run PhageWars++ 
;; in the terminal.  It will explode if enabled in emacs.
(define *COLOR* #f)
;; Color Values:
(define *P1-COLOR* "\033[22;31m")
(define *P2-COLOR* "\033[22;36m")
(define *N-COLOR*  "\033[22;37m")

;; Modifying these requires string swapping the values below.
;; 
;;    " \033[22;31m "
;; to
;;    " \033[22;35m "
;;
;; Black  = "\033[22;30m"
;; Red    = "\033[22;31m"
;; Green  = "\033[22;32m"
;; Yellow = "\033[22;33m"
;; Blue   = "\033[22;34m"
;; Violet = "\033[22;35m"
;; Cyan   = "\033[22;36m"
;; White  = "\033[22;37m"



;; Symbols used to keep track of players.
(define *NEUTRAL-SYMBOL* 'N)
(define *PLAYER-1-SYMBOL* 'P1)
(define *PLAYER-2-SYMBOL* 'P2)
(define *PLAYER-1-OVERTIME* 'P1-ot)
(define *PLAYER-2-OVERTIME* 'P2-ot)
(define *BOTH-OVERTIME* 'both-ot)
(define *TIE* 'tie)


;; Symbols used to draw the board.
(define *HORIZ-BAR* "-------")
(define *VERT-BAR* "|")
(define *OPEN-HORIZ* "       ")
(define *OPEN-SPACE* " ")

(define *PLAYER-1-STRING* "P1")
(define *PLAYER-2-STRING* "P2")
(define *NEUTRAL-STRING* " N")

(define *BREAK-CHAR* ":")
(define *ALT-BREAK-CHAR* "-")
(define *INCOME-CHAR* "+")
(define *SQUARE-CORNER* "*")

(define *ENRAGE-STR* "Enrage: ")
(define *TURN-STR* "Turn: ")
(define *QUEUE-STR* "Queue")


;; Prompt Strings
(define *CELL-PROMPT* 
  (string-append "Select a target Cell (1-" (number->string *NUM-CELLS*) "): "))
  
(define *PLAYER-1-PROMPT* "Player 1's Turn")
(define *PLAYER-2-PROMPT* "Player 2's Turn")
(define *WAIT-PROMPT*    "Hit enter to continue:")

;; Invalid Cell Strings
(define *INVALID-CELL-STRING* "Invalid cell specified.")
(define *DUPLICATE-CELL-STRING* "This cell will defend this turn.\n")

;; Game Over Strings
(define *GAME-OVER-INVALID-MOVE*    "\nGame Over!\nInvalid move by ")
(define *GAME-OVER-PLAYER-1-STRING* "\nGame Over!\nPlayer 1 wins.\n")
(define *GAME-OVER-PLAYER-2-STRING* "\nGame Over!\nPlayer 2 wins.\n")
(define *GAME-OVER-TIE-GAME-STRING* "\nGame Over!\nToo many turns played, the game was a tie.\n")

;; Time Display Strings
(define *P1-TIME-STRING* "Player 1's longest move: ")
(define *P2-TIME-STRING* "Player 2's longest move: ")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  LOAD EXTERNAL FILES  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load "util.scm")  ;; General Utility Procedures
(load "help.scm")  ;; PhageWars++ Helper Procedures
(load "maps.scm")  ;; Map storage file


;; Global useful definitions.  Do not modify.
(define disp-board #f)
(define current-board #f)
(define current-queue #f)
(define display-queue #f)
(define player-procedure #f)

;; This is haxx.  If it's crashing here, check what version of scheme you're on and let a TA know.
(define (sleep-ms t)
  (define (helper t)
    (if (> (system-clock) t)
    0
    (helper t)))
  (helper (+ (system-clock) (/ t 1000))))



;; Run AIs against eachother on a specific map several times.
;; This will NOT show the games in the console, to keep it fast.
;; If run-tests crashes, you must run "reset-display" below, or 
;; you won't be able to see the game being played.
;; Also, *stall* will be left #f and in AI-AI games the delay will
;; be close to zero, until you reset the variables or reload PhageWars++
(define (run-tests player1 player2 number-of-games . map-selection )

	;; Disables the display and newline procedures.  AIs should not call this.	 
	(define (hide-display)	 
		 (set! newline  
			 (let ((old-newline newline))
			   (define (temp-newline . args) ;; Using define rather than lambda
				 (if (and (not (null? args)) 
						  (eq? (car args) 'reset))
					 (set! newline old-newline) #f))
			   temp-newline))

	   (set! display
			 (let ((old-display display))
			   (define (temp-display . args) ;; Using define rather than lambda
				 (if (and (not (null? args)) 
						  (eq? (car args) 'reset))
					 (set! display old-display) #f))
			   temp-display))
		)
	(if (or (eq? player1 'human) (eq? player2 'human))
		(begin (display "Both players must be AIs for run-tests") 'done)
		(let (
			(p1 0)
			(p2 0)
			(tie 0)
			(p1-ot 0)
			(p2-ot 0)
			(game-number 0)
			(old-stall *STALL*)
			(old-sleep *SLEEP-MILLISECONDS*))
 
			(set! *STALL* #f)
			(set! *SLEEP-MILLISECONDS* 0)
			(if (not (null? map-selection)) 
				(begin (set! *MAP-SELECTION-MODE* 'specific) (set! *SPECIFIC-MAP* (car map-selection))))
			(newline)
			(display (string-append "Playing " (number->string number-of-games) " game(s):"))
			(define (loopy)
				(begin
					(set! game-number (+ 1 game-number))
					(newline)
					(display (string-append "Playing game " (number->string game-number) "... "))
					(flush-output)
					(hide-display)
					(let ((winner (play-game player1 player2)))
						(reset-display)
						(newline)
						(if *TIME-LIMIT-ON?*
							(begin 
								(cond ((eq? (car winner) *PLAYER-1-SYMBOL*) (begin (display "Player 1 wins!") (set! p1 (+ p1 1))))
									  ((eq? (car winner) *PLAYER-2-SYMBOL*) (begin (display "Player 2 wins!") (set! p2 (+ p2 1))))
									  ((eq? (car winner) *TIE*) (begin (display "Tie game!") (set! tie (+ tie 1)))))
								(if (eq? (cadr winner) *PLAYER-1-OVERTIME*) (begin (display "\nPlayer 1 went over time.") (set! p1-ot (+ p1-ot 1))))
								(if (eq? (caddr winner) *PLAYER-2-OVERTIME*) (begin (display "\nPlayer 2 went over time.") (set! p2-ot (+ p2-ot 1))))
								)
							
							(cond ((eq? winner *PLAYER-1-SYMBOL*) (begin (display "Player 1 wins!")(set! p1 (+ p1 1))))
								  ((eq? winner *PLAYER-2-SYMBOL*) (begin (display "Player 2 wins!")(set! p2 (+ p2 1))))))
						(if (< game-number number-of-games) (loopy))))
				)
							  
			(loopy)	
			(newline)
			(set! *STALL* old-stall)
			(set! *SLEEP-MILLISECONDS* old-sleep)
			(display (string-append "Player 1 wins: " (number->string p1) "\n"))
			(display (string-append "Player 2 wins: " (number->string p2) "\n"))
			(display (string-append "Ties: " (number->string tie) "\n"))
			(if (> p1-ot 0) (display "Player 1 went over the time-limit."))
			(if (> p2-ot 0) (display "Player 2 went over the time-limit."))
			(cond ((= p1 p2) *TIE*)
				  ((> p1 p2) *PLAYER-1-SYMBOL*)
				  ((> p2 p1) *PLAYER-2-SYMBOL*)
				  (else "Something went wrong, this value should not be displayed")))
	)
)
	 

;; Resets the display and newline procedure.  Call this whenever
;; run-tests crashes, if you can't get any output.
(define (reset-display)
	(display 'reset)
	(newline 'reset)
	'done)
	 
;#;;;;;;;;;;;;;;;;;;;;;;;;;;#;
;#;#;#  MAIN PROCEDURE  #;#;#;
;#;;;;;;;;;;;;;;;;;;;;;;;;;;#;

(define (play-game player1-file player2-file)
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;  DISPLAY PROCEDURES   ;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;; Short-Hand Definitions for Spacing
	(define 1e " ")      (define 5e "     ")     (define 9e  "         ")
	(define 2e "  ")     (define 6e "      ")    (define 10e "          ")
	(define 3e "   ")    (define 7e "       ")   (define 11e "           ")
	(define 4e "    ")   (define 8e "        ")  (define 12e "            ")
	
	;; Set up for quick display
	(define (set-up-display-board board)
		(define (zeroes len)
			(if (= len 0)
				'()
				(cons 0 (zeroes (- len 1)))))
		(define (make-list proc input n)
			(if (= n 0) '()
				(cons (proc input) (make-list proc input (- n 1)))))
		(define (step-n n lst)
			(if (= n 0) lst
				(step-n (- n 1) (cdr lst))))
                (define tmpboard (make-list zeroes *NUM-COLUMNS* *NUM-ROWS*))
		(for-each 
			(lambda (x) 
				(let ((r (cadr x)) (c (caddr x)))
					(set-car! (step-n (- c 1) (list-ref tmpboard (- r 1))) (car x)))) board)
		tmpboard
	)
	
	
	;; Winner procedure, false if there is no winner yet
	(define (get-winner board)
		(let* ((pboard (filter (lambda (x) (if (eq? (list-ref x 3) *NEUTRAL-SYMBOL*) #f #t)) board))
			   (p1board (filter (lambda (x) (eq? (list-ref x 3) *PLAYER-1-SYMBOL*)) pboard)))
			(if (and *TIME-LIMIT-ON?* (> *CURRENT-TURN* *MAX-TURNS*))
				*TIE*
				(if (= (length p1board) 0)
					*PLAYER-2-SYMBOL*
					(if (= (length p1board) (length pboard))
						*PLAYER-1-SYMBOL*
						#f)))))
	
	
	;N MUST BE GREATER THAN OR EQUAL TO 1
	(define (repeat n char)
		(if (<= n 0) ""
			(if (= n 1) char
				(string-append char (repeat (- n 1) char)))))
	
	(define (board->string display-board board queue) ;; Add queue later\
		
		(define (cell-lookup n board level)
			;(if tests (display+ "Cell Lookup finding " n " with level " level "\n"))
			(let ((cell (find-tagged-sublist n board)))
				(if cell
					(if (= level 1)
						(string-append 
							(if (> n 9) "C" " C")
							(number->string n) 
							*BREAK-CHAR*
							*INCOME-CHAR* (number->string (list-ref cell 3)) *OPEN-SPACE*)
						;;Else height == 2
						(string-append
							*OPEN-SPACE* (player-string (caddr cell))
							*BREAK-CHAR*
							(let* ((n (list-ref cell 4))
									(num (number->string n)))
								(if (< n 10)
									(string-append "0" (substring num 0 1) *OPEN-SPACE*)
									(if (< n 100)
										(string-append (substring num 0 2) *OPEN-SPACE*)
										;;Else unit count 100+
										(substring num 0 3)))
							)))
									
					(error "Bad cell number passed to cell-lookup"))))
		
		(define (queue-lookup n disp-queue level)
			(let* ((cell (find-tagged-sublist n disp-queue))
			      (color-str (if *COLOR* (if (eq? *PLAYER-1-SYMBOL* (get-owner-queued (car cell))) *P1-COLOR* *P2-COLOR*) ""))
			      (color-str2 (if *COLOR* *N-COLOR* "")))
				(if cell
					(if (= level 1)
						(let ((count (unit-count-queued (car cell))))
							(string-append 
							 color-str
								(if (< count 10)
									(string-append " 0" (substring (number->string count) 0 1))
									(if (< count 100)
										(string-append " " (substring (number->string count) 0 2))
											(substring (number->string count) 0 3)))
								*BREAK-CHAR*
								"C"
								(if (< 9 (get-destination-queued (car cell)))
									(substring (number->string (get-destination-queued (car cell))) 0 2)
									(substring (number->string (get-destination-queued (car cell))) 0 1))
								(if (< 9 (get-destination-queued (car cell)))
									""
									*OPEN-SPACE*)
								color-str2))
						(string-append
							3e
							color-str
							(player-string (get-owner-queued (car cell)))
							color-str2
							2e))
					
					(error "Bad cell number passed to queue-lookup"))))
				
		(define (make-top-bottom row)
			;(if tests (display+ "Make-top-bottom with row " row "\n"))
			(if (null? row) 
				(string-append *SQUARE-CORNER* ":\n")
				(if (= *NUM-COLUMNS* (length row))
					(string-append ":" 
						*SQUARE-CORNER*
						(if (< (car row) 1)
							*OPEN-HORIZ*
							(if *COLOR*
								(if (eq? *PLAYER-1-SYMBOL* (get-owner (car row) board))
									(string-append *P1-COLOR* *HORIZ-BAR* *N-COLOR*)
									(if (eq? *PLAYER-2-SYMBOL* (get-owner (car row) board))
										(string-append *P2-COLOR* *HORIZ-BAR* *N-COLOR*)
										*HORIZ-BAR*))
							*HORIZ-BAR*))
							(make-top-bottom (cdr row)))
					(string-append  
						*SQUARE-CORNER*
						(if (< (car row) 1)
							*OPEN-HORIZ*
							(if *COLOR*
								(if (eq? *PLAYER-1-SYMBOL* (get-owner (car row) board))
									(string-append *P1-COLOR* *HORIZ-BAR* *N-COLOR*)
									(if (eq? *PLAYER-2-SYMBOL* (get-owner (car row) board))
										(string-append *P2-COLOR* *HORIZ-BAR* *N-COLOR*)
										*HORIZ-BAR*))
							*HORIZ-BAR*))
							(make-top-bottom (cdr row))))))
							
		(define (make-between above-row below-row)
			;(if tests (display+ "Make-between with " above-row below-row "\n"))
			(if (null? above-row) 
				(string-append *SQUARE-CORNER* ":\n")
				(if (= *NUM-COLUMNS* (length above-row))
					(string-append ":" 
						*SQUARE-CORNER*
						(if (and (< (car above-row) 1) (< (car below-row) 1))
							*OPEN-HORIZ*
							(if *COLOR*
								(if (eq? *PLAYER-1-SYMBOL* (get-owner (max (car above-row) (car below-row)) board))
									(string-append *P1-COLOR* *HORIZ-BAR* *N-COLOR*)
									(if (eq? *PLAYER-2-SYMBOL* (get-owner (max (car above-row) (car below-row)) board))
										(string-append *P2-COLOR* *HORIZ-BAR* *N-COLOR*)
										*HORIZ-BAR*))
							*HORIZ-BAR*))
						(make-between (cdr above-row) (cdr below-row)))
					(string-append  
						*SQUARE-CORNER*
						(if (and (< (car above-row) 1) (< (car below-row) 1))
							*OPEN-HORIZ*
							(if *COLOR*
								(if (eq? *PLAYER-1-SYMBOL* (get-owner (max (car above-row) (car below-row)) board))
									(string-append *P1-COLOR* *HORIZ-BAR* *N-COLOR*)
									(if (eq? *PLAYER-2-SYMBOL* (get-owner (max (car above-row) (car below-row)) board))
										(string-append *P2-COLOR* *HORIZ-BAR* *N-COLOR*)
										*HORIZ-BAR*))
							*HORIZ-BAR*))
						(make-between (cdr above-row) (cdr below-row))))))
							
		(define (make-middle row s1 s2 t) ;t is #t if last column had a cell
			;(if tests (display+ "Make Middle: " row "\n"))
			(if (null? row) 
				(if t
					(string-append s1 *VERT-BAR* (if *COLOR* *N-COLOR* "") ":\n" s2 *VERT-BAR* (if *COLOR* *N-COLOR* "") ":\n")
					(string-append s1 *OPEN-SPACE* ":\n" s2 *OPEN-SPACE* ":\n"))
				(make-middle (cdr row)
					(string-append s1
						(if (and (< (car row) 1) (eq? t #f))
							*OPEN-SPACE*
							(if (and *COLOR* (eq? t #f))
								(if (eq? *PLAYER-1-SYMBOL* (get-owner (car row) board))
									(string-append *P1-COLOR* *VERT-BAR*)
									(if (eq? *PLAYER-2-SYMBOL* (get-owner (car row) board))
										(string-append *P2-COLOR* *VERT-BAR*)
										*VERT-BAR*))
								*VERT-BAR*))
						(if (and *COLOR* (eq? t #t))
							*N-COLOR* "")
						(if (= (car row) 0)
							*OPEN-HORIZ*
							(if (> (car row) 0)
								(cell-lookup (car row) board 1)
								(queue-lookup (car row) display-queue 1)
								)))
					(string-append s2
						(if (and (< (car row) 1) (eq? t #f))
							*OPEN-SPACE*
							(if (and *COLOR* (eq? t #f))
							    (if (eq? *PLAYER-1-SYMBOL* (get-owner (car row) board))
								(string-append *P1-COLOR* *VERT-BAR*)
								(if (eq? *PLAYER-2-SYMBOL* (get-owner (car row) board))
								    (string-append *P2-COLOR* *VERT-BAR*) 
								    *VERT-BAR*))
							    *VERT-BAR*))
							(if (and *COLOR* (eq? t #t))
								*N-COLOR* "")
						(if (= (car row) 0)
							*OPEN-HORIZ*
							(if (> (car row) 0)
								(cell-lookup (car row) board 2)
								(queue-lookup (car row) display-queue 2)
								)))
					(if (< (car row) 1)
						#f
						#t))
			))

		(define (internal-loop display-board board) ;Start at row 0
			(if (= (length display-board) 1) 
				(make-middle (car display-board) ":" ":" #f)
				(string-append
					(make-middle (car display-board) ":" ":" #f)
					(make-between (car display-board) (cadr display-board))
					(internal-loop (cdr display-board) board))))
		
		(define (calculate-move-locations queue disp-board)
			(define (step-n n lst)
				(if (= n 0) lst
					(step-n (- n 1) (cdr lst))))
			(define (get-x-y queue-move disp-board)
				(let* ((start-row (car (find-tagged-sublist (get-origin-queued queue-move) board))) 
					   (start-column (cadr (find-tagged-sublist (get-origin-queued queue-move) board)))
					   (target-row (car (find-tagged-sublist (get-destination-queued queue-move) board))) 
					   (target-column (cadr (find-tagged-sublist (get-destination-queued queue-move) board)))
					   (total-dist (distance (get-destination-queued queue-move) (get-origin-queued queue-move) current-board))
					   (cur-dist (get-distance-queued queue-move))
					   (net-dist (- 1 (/ cur-dist total-dist)))
					   (new-column (inexact->exact (round (+ start-column (* (- target-column start-column) net-dist)))))
					   (new-row (inexact->exact (round (+ start-row (* (- target-row start-row) net-dist))))))
					(begin 
						(if tests (display+ "Inside get-x-y with queue-move " queue-move 
							", new-row " new-row " and new-column " new-column "\n"
							"Total distance is " total-dist ", and net-dist is " net-dist "\n"))
						
						(if (= 0 (list-ref (list-ref disp-board (- new-row 1)) (- new-column 1)))
							(cons new-row new-column) 
							(let ((guess-y (if (= start-row target-row) 0 (if (> start-row target-row) 1 -1)))
								  (guess-x (if (= start-column target-column) 0 (if (> start-column target-column) 1 -1))))
								(if (or (< (+ guess-y (- new-row 1)) 0) 
										(< (+ guess-x (- new-column 1)) 0) 
										(> (+ guess-y (+ new-row 1)) *NUM-ROWS*) 
										(> (+ guess-x (+ new-column 1)) *NUM-COLUMNS*))
										(begin (if tests (display "Ignoring a bad guess.\n")) #f)
										(if (= 0 (list-ref (list-ref disp-board (+ guess-y (- new-row 1))) (+ guess-x (- new-column 1))))
											(cons (+ guess-y new-row) (+ guess-x new-column))
											#f)))))))


			(define (iterator index queue disp-board newlist)
				(if (null? queue) 
					(begin (if tests (display+ "Return from calculate-move-locations: " newlist "\n")) newlist)
					(let ((point (get-x-y (car queue) disp-board)))
						(if point
							(begin
								(set-car! (step-n (- (cdr point) 1) (list-ref disp-board (- (car point) 1))) index)
								(iterator (- index 1) (cdr queue) disp-board 
									(if (null? newlist)
										(list (list index (car queue)))
										(append newlist (list (list index (car queue)))))))
							(iterator index (cdr queue) disp-board newlist)))))
			(begin 
			;(display+ "Entering iterator with queue: " queue "\nAnd board: " disp-board "\n")
			(iterator -1 queue disp-board '()))
						  
		)
		
		
		(if *DISPLAY-MOVES-ON-BOARD*
			(set! display-queue (calculate-move-locations queue display-board)))
		
		(string-append
			(if *COLOR* *N-COLOR* "")
			"." (repeat (+ 1 (* 8 *NUM-COLUMNS*)) "=") ".\n"
				(make-top-bottom (car display-board))
				(internal-loop display-board board)
				(make-top-bottom (list-ref display-board (- (length display-board) 1)))
			"`" (repeat (+ 1 (* 8 *NUM-COLUMNS*)) "=") "`\n")
			
	)

	(define (queue->string queue)
		;;Display owner, destination, unitcount, number of turns (ceiling (/ distance 3))
		;;height: 1 + 3*row + 1 + 1
		;;width: 1 + 8*col + 1 + 1
		(if tests (display+ "Making queue.\n"))
		(define (get-queue-unitcount-str queue-move)
			(let* ((num (number->string (unit-count-queued queue-move)))
				   ;(num (substring n 0 (- (string-length n) 1)))
				   )
				(if (= 1 (string-length num))
					(string-append " 0" num)
					(if (= 2 (string-length num))
						(string-append " " num)
						;;Else unit count 100+
						num))))	
		(define (get-queue-turns-left queue-move)
			(let* ((d (cadr queue-move))
				   (t (/ d *MOVE-SPEED*))
				   (turns (number->string (inexact->exact (ceiling t))))
				   ;(turns (substring tu 0 (- (string-length tu) 1)))
				   )
				(if (= 1 (string-length turns))
					(string-append "0" turns)
					turns))) ;; It will NEVER be triple digit turns left (I hope)
		
		(define (generate-middle queue s1 s2 count)
			(if (null? queue)
				(if (= count 0) 
					(let* ((s1 (if (null? s1) "" s1))
						   (s2 (if (null? s2) "" s2))
							(tmp (repeat (+ (* 8 *NUM-COLUMNS*) 1) " ")))
						(string-append s1 "|" tmp "|\n" s2 "|" tmp "|\n"))
					(let* ((s1 (if (null? s1) "  " s1))
						   (s2 (if (null? s2) "  " s2))
						   (colorlen (if *COLOR* 
											(* (string-length *P1-COLOR*) 2 count)
											0))
							(tmp (repeat (- (* 8 *NUM-COLUMNS*) (- (string-length s1) colorlen)) " ")))
						(if (= (string-length tmp) 0)
							(string-append s1 "  |\n" s2 "  |\n")
							(string-append s1 "|" tmp " |\n" s2 "|" tmp " |\n"))))
				(if (< count *NUM-COLUMNS*)
						(if (= count 0)
							(generate-middle (cdr queue)
								(string-append "| "
									(if *COLOR* 
										(if (eq? *PLAYER-1-SYMBOL* (get-owner-queued (car queue)))
											*P1-COLOR*
											(if (eq? *PLAYER-2-SYMBOL* (get-owner-queued (car queue)))
												*P2-COLOR*
												""))
												"")
									(get-queue-unitcount-str (car queue))
									*BREAK-CHAR*
									"C"
									(number->string (list-ref (car queue) 3))
									(if *COLOR* *N-COLOR* "")
									(if (not (< 9 (list-ref (car queue) 3))) " " ""))
								(string-append "|  "
									(if *COLOR* 
											(if (eq? *PLAYER-1-SYMBOL* (get-owner-queued (car queue)))
												*P1-COLOR*
												(if (eq? *PLAYER-2-SYMBOL* (get-owner-queued (car queue)))
													*P2-COLOR*
													""))
													"")
									(player-string (list-ref (car queue) 5))
									*BREAK-CHAR*
									(get-queue-turns-left (car queue))
									(if *COLOR* *N-COLOR* "")
									" ")
								(+ count 1))
							(generate-middle (cdr queue)
								(string-append s1 "|"
									(if *COLOR* 
										(if (eq? *PLAYER-1-SYMBOL* (get-owner-queued (car queue)))
											*P1-COLOR*
											(if (eq? *PLAYER-2-SYMBOL* (get-owner-queued (car queue)))
												*P2-COLOR*
												""))
												"")
									(get-queue-unitcount-str (car queue))
									*BREAK-CHAR*
									"C"
									(number->string (list-ref (car queue) 3))
									(if *COLOR* *N-COLOR* "")
									(if (not (< 9 (list-ref (car queue) 3))) " " ""))
								(string-append s2 "| "
									(if *COLOR* 
										(if (eq? *PLAYER-1-SYMBOL* (get-owner-queued (car queue)))
											*P1-COLOR*
											(if (eq? *PLAYER-2-SYMBOL* (get-owner-queued (car queue)))
												*P2-COLOR*
												""))
												"")
									(player-string (list-ref (car queue) 5))
									*BREAK-CHAR*
									(get-queue-turns-left (car queue))
									(if *COLOR* *N-COLOR* "")
									" ")
									(+ count 1)))
					(string-append s1 " |\n" s2 " |\n"))))

		(define (row-splitter queue)
			(define (helper c q)
				(if tests (display+ "In R-S helper, c = " c " queue = " q "\n"))
				(if (= c 0) q
					(helper (- c 1) (cdr q))))
			(if (not (null? queue))
				(if (> (length queue) *NUM-COLUMNS*)
					(string-append (generate-middle queue '() '() 0)
						":" (repeat (+ (* 8 *NUM-COLUMNS*) 1) "-") ":\n"
						(row-splitter (helper *NUM-COLUMNS* queue)))
					(generate-middle queue '() '() 0)
						)
				(generate-middle queue '() '() 0)
			)
		)
		
		(let* ((enrage-val-str (number->string (get-enrage-value *CURRENT-TURN*)))
			   (r-enrage-val-str (if (> (string-length enrage-val-str) 4) (substring enrage-val-str 0 4) enrage-val-str)))
			(string-append
				(if *COLOR* *N-COLOR* "")
				".=Queue"
				(repeat (- (* 8 *NUM-COLUMNS*) 14) "=")
				"Speed: " (number->string *MOVE-SPEED*) "=.\n"
				(row-splitter queue)
				"`=" *ENRAGE-STR* r-enrage-val-str
				(repeat (- (* 8 *NUM-COLUMNS*)
					(+ 17 (string-length r-enrage-val-str))) "=")
				*TURN-STR* (number->string *CURRENT-TURN*)
				(let ((c (number->string *CURRENT-TURN*)))
					(if (= (string-length c) 1)
						"==`\n"
						(if (= (string-length c) 2)
							"=`\n"
							"`\n")))
			)
		)
	)
	
	
	;; Map initialization function
	(define (load-map)
		(define mapSelection
			(if (eq? *MAP-SELECTION-MODE* 'specific)
				(if *SPECIFIC-MAP*
					(find-tagged-sublist *SPECIFIC-MAP* (mapList))
					(error "Unspecified map name in PhageWars++.scm"))
				(cdr (list-ref (mapList) (random (length (mapList)))))))
		(if (not mapSelection)
			(error "Map loading error.  If you set a specific map, make sure the map name corresponds to an item in the list at the bottom of maps.scm"))
		
		(let ((dimensions (find-tagged-sublist 'dimensions mapSelection))
			  (board (find-tagged-sublist 'board mapSelection))
			  (queue (find-tagged-sublist 'queue mapSelection))
			  (speed (find-tagged-sublist 'speed mapSelection))
			  (turn (find-tagged-sublist 'turn mapSelection))
			  (enrageValues (find-tagged-sublist 'enrage mapSelection))
			  (defender-bonus (find-tagged-sublist 'defender-bonus mapSelection))
			  (time-limit (find-tagged-sublist 'time-limit mapSelection)))
			(begin
				(set! *NUM-ROWS* (car dimensions))
				(set! *NUM-COLUMNS* (cadr dimensions))
				(if speed (set! *MOVE-SPEED* (car speed)))
				(if turn (set! *CURRENT-TURN* (car turn)) (set! *CURRENT-TURN* 1))
				(if enrageValues 
					(begin
						(set! *ENRAGE-VALUE-INITIAL* (car enrageValues))
						(set! *ENRAGE-TURN-INCREMENT* (cadr enrageValues))
						(set! *ENRAGE-INCREMENT* (caddr enrageValues))))
				(if defender-bonus (set! *DEFENDER-BONUS* (car defender-bonus)))
				(if time-limit (set! *AI-TIME-LIMIT* (car time-limit)))
				(set! current-board (car board))
				(set! *NUM-CELLS* (length current-board))
				(set! *CELL-PROMPT*
					(string-append 
						"Select a target Cell (1-" 
						(number->string *NUM-CELLS*) 
						"): "))
				(set! disp-board (set-up-display-board current-board))
				(set! current-queue (make-queue))
			)
		)
	)
	
    ;; Forces Loop To Pause
    (define (do-delay)
	  (if (not (or (eq? player1-file 'human) 
	   (eq? player2-file 'human)))
		(if (not (<= *SLEEP-MILLISECONDS* 0))
		  (begin
			(flush-output) 
			(sleep-ms *SLEEP-MILLISECONDS*)
			(if *STALL* 
			(begin (display *WAIT-PROMPT*) 
				   (flush-output) 
				   (read-line)
				   (newline)))))))


	
	;; Convert file string to player-procedure
    (define (file->player file)
    	(cond ((equal? file 'human) 'human)
			(else
				(load file)
				(if player-procedure
					player-procedure
					(error "player-procedure not properly defined.")))))
	
	(define (read-line)
		(let ((char (peek-char)))
			(if (eof-object? char)
				char
				(list->string
					(let loop ((char char))
						(if (or (eof-object? char)
								(equal? #\newline char)
								(equal? #\return char)
								(equal? #\linefeed char))
							(begin
								(read-char)
								'())
							(begin
								(read-char)
								(cons char
								(loop (peek-char))))))))))
								
								
								
	;; Gets a move from the human and doesn't give up
	(define (get-human-move player board board-string)

		;; Prompts for human player to input a target
		(define (get-move origin)
		  (let ((destination '()))
			(newline) (display (string-append 
						"What would you like to do with cell " 
						(number->string origin)
						"?"))
			(newline) (display *CELL-PROMPT*) (flush-output) (set! destination (read))
			(if (= origin destination)
				(begin 
					(newline) 
					(display *DUPLICATE-CELL-STRING*)
					#f)
				(if (= destination origin)
					#f
					(if (not (<= 1 destination *NUM-CELLS*))
						(begin
							(newline)
							(display *INVALID-CELL-STRING*)
							(do-delay)
							(get-move origin))
						(make-move origin destination))))))
			
		(define (generate-move-list player-cells)
			(let ((moves (map (lambda (x) (get-move (car x))) player-cells)))
				(filter (lambda (x) x) moves)))
		
		
		(generate-move-list (get-cell-list player board)))
	
	;; A fun little variable for accurate growth calculations
	(define captures '())
	
	;; After advancing the queue by *MOVE-SPEED*, this executes all moves which are distance <= 0
	(define (execute-moves queue board)
		(if (and (not (null? (cdr queue))) (>= 0 (get-distance-queued (check-front queue))))
			(let* ((front (check-front queue))
				   (destination-cell (find-tagged-sublist (get-destination-queued front) board)))
				;;Check for reinforcing moves, and remove enrage bonus
				(if (eq? (get-owner-queued front)
						 (list-ref destination-cell 2))
					(begin 
						(set-car! (cdddr (cdr destination-cell))
							(+ (list-ref destination-cell 4)
							   (ceiling (* (/ 1 
								  (get-enrage-value (- *CURRENT-TURN* 
									(ceiling (/ (distance (get-origin-queued front) 
										(get-destination-queued front) board) *MOVE-SPEED*)))))
								  (unit-count-queued front)))))
						(remove-front queue)
						(execute-moves queue board))
					;;Attacking move
					(begin
						(set-car! (cdddr (cdr destination-cell))
							(- (list-ref destination-cell 4)
								(unit-count-queued front)))
						(if (> 0 (list-ref destination-cell 4))
							(begin
								(set-car! (cddr destination-cell)
									(get-owner-queued front))
								(set! captures (append captures (list (get-destination-queued front))))
								(set-car! (cdddr (cdr destination-cell)) 
								          (* -1 (list-ref destination-cell 4)))
										  ))
						(remove-front queue)
						(execute-moves queue board)))
			)
		)
	)
	
	;;Prevents an AI from returning multiple moves from a single cell, or returning moves for their opponent :P
	(define (legal-moves? movelist player board)
		(if tests (display+ "inside legal-moves for " player ", checking " movelist "\n"))
		(define (no-duplicates? n numbered-list)
			(if (null? numbered-list)
				#t
				(if (= n (car numbered-list))
					#f
					(no-duplicates? n (cdr numbered-list)))))
		(define (loop-duplicate-check numbered-list)
			(if (null? numbered-list)
				#t
				(if (no-duplicates? (car numbered-list) (cdr numbered-list))
					(loop-duplicate-check (cdr numbered-list))
					#f)))
		
		(if (< 0 (length (filter (lambda (x) (not (eq? player x)))
								(map (lambda (x) (caddr (find-tagged-sublist (get-move-origin x) board))) movelist))))
			(begin (if tests (display+ "Bad return for " player ", tried to move opponent's cell...  " movelist "\n"))
				#f)
			  (if (loop-duplicate-check (map get-move-origin movelist))
				#t
				(begin (if tests (display+ "Bad return for " player ", duplicate moves found in move list\n"))
					#f))))
						
	;;Increases the cell-count on all non-neutral cells	by their growth value
	(define (execute-growth p1-moves p2-moves board)
		(for-each 
			(lambda (x) 
				(if (not (eq? (list-ref x 3) *NEUTRAL-SYMBOL*))
					(if (> (+ (list-ref x 4) (list-ref x 5)) *MAX-UNITS*)
						(set-car! (cdddr (cddr x)) *MAX-UNITS*)
						(set-car! (cdddr (cddr x)) (+ (list-ref x 4) (list-ref x 5))))))
			board)
		;;Add in the defender's bonus!
		(let* ((attackers (append (map get-move-origin p1-moves) (map get-move-origin p2-moves) captures))
			   (defenders (filter (lambda (x) (if (member (car x) attackers) #f #t)) board)))
			(for-each (lambda (x)
				(if (not (eq? (list-ref x 3) *NEUTRAL-SYMBOL*))
					(if (> (+ *DEFENDER-BONUS* (list-ref x 5)) *MAX-UNITS*)
						(set-car! (cdddr (cddr x)) *MAX-UNITS*)
						(set-car! (cdddr (cddr x)) (+ *DEFENDER-BONUS* (list-ref x 5))))))
				defenders)
				)
	)

	
	(define (just-display-board)
		(let ((board-string (board->string (tree-copy disp-board) current-board (tree-copy (cdr current-queue)))))
			  (newline)
			  (display board-string)
			  (newline)))
		

	;;======================;;
    ;;  Begin Main Process  ;;
    ;;======================;;
	
	;;Load map for the game
	(load-map)
	(if tests (display "Map Loaded...\n"))
	
	(if (and (equal? player1-file 'display) (equal? player2-file 'board))
		(just-display-board)
	;;Set up player procedures
	(let* ((player1-procedure (begin (set! player-procedure #f) (file->player player1-file)))
		(player2-procedure (begin (set! player-procedure #f) (file->player player2-file)))
		(current-player #f)
		(player1-move-list '())
		(player2-move-list '())
		(something-crashed #f)
		(p1-longest 0)
		(p2-longest 0)
		)

		(define (safe-execute proc current-player queue board)
			;; Block some variable access to discourage tampering and cheating
			(let* (
				(*NUM-ROWS* *NUM-ROWS*)
				(*NUM-COLUMNS* *NUM-COLUMNS*)
				(*MOVE-SPEED* *MOVE-SPEED*)
				(*CURRENT-TURN* *CURRENT-TURN*)
				(*ENRAGE-VALUE-INITIAL* *ENRAGE-VALUE-INITIAL*)
				(*ENRAGE-TURN-INCREMENT* *ENRAGE-TURN-INCREMENT*)
				(*ENRAGE-INCREMENT* *ENRAGE-INCREMENT*)
				(*DEFENDER-BONUS* *DEFENDER-BONUS*)
				(*NEUTRAL-SYMBOL* *NEUTRAL-SYMBOL*)
				(*PLAYER-1-SYMBOL* *PLAYER-1-SYMBOL*)
				(*PLAYER-2-SYMBOL* *PLAYER-2-SYMBOL*)
				(*DEFENDER-BONUS* *DEFENDER-BONUS*)
				(current-board current-board)
				(current-queue current-queue)
				(player1-procedure '())
				(player2-procedure '())
				(player1-move-list '())
				(player2-move-list '())
				(current-player current-player)
				(something-crashed '())
				)
				;(define *AI-BEING-TIMED* #f)
				;(define *AI-TIME-LIMIT* 2)	
				(with-timings 
					(lambda ()
						(if *SAFE-PLAYER-EXECUTION*
							;; SAFE-EXECUTE SHOULD BE FALSE UNLESS YOU WANT TO BLINDLY LOSE FROM CRASHING AIs
							(let ((rv 'crashed))
								(ignore-errors (lambda () (set! rv (proc current-player queue board))))
								rv)
							(proc current-player queue board)))
					(lambda (run-time gc-time real-time) 
						(let ((time (internal-time/ticks->seconds real-time)))
							(if (eq? current-player *PLAYER-1-SYMBOL*)
								(if (> time p1-longest)
								(set! p1-longest time))
								(if (> time p2-longest)
								(set! p2-longest time))))))))

							
								
		;;===================;;
		;; Main program loop ;;
		;;===================;;
		(define (loop)
			(if tests (display "Inside loop..\n"))
			(let ((board-string (board->string (tree-copy disp-board) 
						current-board (tree-copy (cdr current-queue))))
				  (queue-string (queue->string (cdr current-queue))))
				  
			;; Gets a move-list from player 1
				(set! current-player *PLAYER-1-SYMBOL*)
				;; Display the board and queue
				(display+ board-string queue-string)
				;;Computer Delay Yeah!
				(do-delay)
				(if (and (eq? 'human player1-procedure) (eq? 'human player2-procedure))
					(begin (newline) (display *PLAYER-1-PROMPT*)))
				(newline)
				(if (eq? player1-procedure 'human)
					(set! player1-move-list (get-human-move current-player current-board board-string))
					(set! player1-move-list 
						(safe-execute player1-procedure current-player 
							(tree-copy current-queue) 
							(tree-copy current-board))))
				;; Check for p1 crashing in a safe execute situation
				(if (eq? player1-move-list 'crashed)
					(begin
						(set! player1-move-list '())
						(set! something-crashed *PLAYER-1-SYMBOL*)
						))
				;; Display the board and queue again?
				(if (and (eq? 'human player1-procedure) (eq? 'human player2-procedure))
					(begin (display+ board-string queue-string) (do-delay)))		
			;; Gets a move-list from player 2
				(set! current-player *PLAYER-2-SYMBOL*)
				(if (and (eq? 'human player1-procedure) (eq? 'human player2-procedure))
					(begin (newline) (display *PLAYER-2-PROMPT*) (newline)))
				(if (eq? player2-procedure 'human)
					(set! player2-move-list (get-human-move current-player current-board board-string))
					(set! player2-move-list 
						(safe-execute player2-procedure current-player
							(tree-copy current-queue)
							(tree-copy current-board))))
				;; Check for p1 crashing in a safe execute situation
				(if (eq? player2-move-list 'crashed)
					(begin
						(set! player2-move-list '())
						(if (not (eq? something-crashed #f))
							(set! something-crashed 'tie)
							(set! something-crashed *PLAYER-2-SYMBOL*))))
			;; Make sure both lists of moves are legitimate moves without duplicate origins.
			(if (or (not (fold-left (lambda (x y) (and x y)) #t (map move? player1-move-list)))
					(not (legal-moves? player1-move-list *PLAYER-1-SYMBOL* current-board)))
				(begin
					(set! player1-move-list '())
					(set! something-crashed *PLAYER-1-SYMBOL*)))
			(if (or (not (fold-left (lambda (x y) (and x y)) #t (map move? player2-move-list)))
					(not (legal-moves? player2-move-list *PLAYER-2-SYMBOL* current-board)))
				(begin
					(set! player2-move-list '())
					(if (not (eq? something-crashed #f))
							(set! something-crashed 'tie)
							(set! something-crashed *PLAYER-2-SYMBOL*))))
			;; Insert moves into queue
			(if tests (display+ player1-move-list "\n"))
			(if tests (display+ player2-move-list "\n"))
			;; Filter out moves with the same origin and destination (AIs might return this, it's okay)
			(set! player1-move-list (filter (lambda (x) (if (= (get-move-origin x) (get-move-destination x)) #f #t)) player1-move-list))
			(set! player2-move-list (filter (lambda (x) (if (= (get-move-origin x) (get-move-destination x)) #f #t)) player2-move-list))
			(for-each (lambda (x) ;Insert player 1's moves.
				(insert-queue (move->queued-move (get-move-origin x) (get-move-destination x) current-board) current-queue)) player1-move-list)
			(for-each (lambda (x) ;Lower unit count in remaining cells for p1
				(set-car! (cdddr (cdr (find-tagged-sublist (get-move-origin x) current-board)))
						(get-remaining-count (get-move-origin x) current-board))) player1-move-list)
			(for-each (lambda (x) ;Insert player 2's moves.
						(insert-queue (move->queued-move (get-move-origin x) (get-move-destination x) current-board) current-queue)) player2-move-list)
			(for-each (lambda (x) ;Lower unit count in remaining cells for p1
				(set-car! (cdddr (cdr (find-tagged-sublist (get-move-origin x) current-board)))
						(get-remaining-count (get-move-origin x) current-board))) player2-move-list)
			(if tests (display+ "Queue before: " current-queue "\n"))
			;; Advance all moves in the queue by move-speed
			(for-each (lambda (x) (set-car! (cdr x) (- (cadr x) *MOVE-SPEED*))) (cdr current-queue))
			
			(if tests (display+ "Queue advanced: " current-queue "\n"))
			(execute-moves current-queue current-board)
			(if tests (display+ "Queue after execution: " current-queue "\n"))
			(execute-growth player1-move-list player2-move-list current-board)

			;; Reset captured cell tracker
			(if tests 
				(display+ "Cells captured this turn " captures "\n"))
			(set! captures '())
			
			(let ((winner (get-winner current-board)))
				;;Check for crashes
				(if (not (eq? #f something-crashed))
					(begin 
						(if tests (display+ "Something Crashed! " something-crashed "\n"))
						(if (eq? something-crashed *PLAYER-1-SYMBOL*)
							(begin
								(display+ *GAME-OVER-INVALID-MOVE* "player 1.\n")
								*PLAYER-2-SYMBOL*)
							(if (eq? something-crashed *PLAYER-2-SYMBOL*)
								(begin
									(display+ *GAME-OVER-INVALID-MOVE* "player 2.\n")
									*PLAYER-1-SYMBOL*)
								(if (eq? something-crashed 'tie)
									(begin 
										(display+ *GAME-OVER-INVALID-MOVE* "both players.\n")
										'tie)
									(display+ "Something crazy just happened and something-crashed returned " something-crashed)))))
					
					(if winner
						(begin
							(display (board->string (tree-copy disp-board) current-board (tree-copy (cdr current-queue))))
							(display+ "\n" *P1-TIME-STRING* p1-longest " seconds.\n")
							(display+ *P2-TIME-STRING* p2-longest " seconds.\n")
							(if (eq? *PLAYER-1-SYMBOL* winner)
								(display *GAME-OVER-PLAYER-1-STRING*)
								(if (eq? *PLAYER-2-SYMBOL* winner)
									(display *GAME-OVER-PLAYER-2-STRING*)
									(display *GAME-OVER-TIE-GAME-STRING*)))
							;;NYI - Flip winner value if *TIME-LIMIT-ON?* is true
							(if *TIME-LIMIT-ON?*
								(list winner 
										(if (> p1-longest *AI-TIME-LIMIT*) *PLAYER-1-OVERTIME* #f)
										(if (> p2-longest *AI-TIME-LIMIT*) *PLAYER-2-OVERTIME* #f))
							winner))
					;;No winner, update turn and loop
					(begin
						(set! *CURRENT-TURN* (+ *CURRENT-TURN* 1))
						(set! display-queue #f)
						(loop)))))))
						

			(loop)
	))
)
				
				

