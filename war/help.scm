;==============================================================================;
;         Computer Science 1901 - Fall 2013 - University of Minnesota        ;
;                             Final Course Project                             ;
;==============================================================================;
;  Helper Procedures For PhageWars++.scm                                       ;
; ----------------------------------                                           ;
;  Notes:                                                                      ;
;   + This file is loaded by PhageWars++.scm.                                  ;
;   + Your player-procedure has access to these procedures through the top     ;
;      level environment.  There is no need to copy them in to your file.      ;
;   + Do not submit this file.                                                 ;
;==============================================================================;

;;;=====================;;;
;;;  STRINGS & SYMBOLS  ;;;
;;;=====================;;;

;; Gets the player symbol for the other player
(define (other-player  player-symbol)
  (if (eq? player-symbol *PLAYER-1-SYMBOL*)
      *PLAYER-2-SYMBOL*
      *PLAYER-1-SYMBOL*))

;; Gets the prompt string for the given player
(define (prompt-string player-symbol)
  (if (eq? player-symbol *PLAYER-1-SYMBOL*) 
      *PLAYER-1-PROMPT* 
      *PLAYER-2-PROMPT*))

;; Gets the player string for a given player
(define (player-string player-symbol)
  (if (eq? player-symbol *PLAYER-1-SYMBOL*) 
      *PLAYER-1-STRING* 
      (if (eq? player-symbol *PLAYER-2-SYMBOL*)
	  *PLAYER-2-STRING*
	  *NEUTRAL-STRING*)))

;;;================================;;;
;;;  BOARD INFORMATION PROCEDURES  ;;;
;;;================================;;;

;; GET-CELL-LIST
;; input: a player symbol and the board
;; return: a list of all cells owned by player 
(define (get-cell-list player board)
  (filter (lambda (x) (eq? player (list-ref x 3))) board)
  )

;; GET-CELL-NUMBER-LIST
;; input: a player symbol and the board
;; return: a list of the numbers of each cell owned by player
(define (get-cell-number-list player board)
  (map car (get-cell-list player board))
  )


;; GET-ENRAGE-VALUE
;; input: a turn number
;; return: the enrage value on the specified turn
(define (get-enrage-value turn-number)
  (+ 
   (* (floor (/ turn-number *ENRAGE-TURN-INCREMENT*)) *ENRAGE-INCREMENT* 1.0) 
   *ENRAGE-VALUE-INITIAL*)
  )


;; DISPLAY-SPECIFIC-BOARD
;; input: a quoted map name ie: 'map7
;; return: none. Displays how the specified map looks at turn one
;; NOTE: your AI should not call this procedure
(define (display-specific-map mapname)
	(let ((orig *SPECIFIC-MAP*)
	      (old-setting *MAP-SELECTION-MODE*))
	      	(set! *MAP-SELECTION-MODE* 'specific)
		(set! *SPECIFIC-MAP* mapname)
		(play-game 'display 'board)
		(set! *SPECIFIC-MAP* orig)
		(set! *MAP-SELECTION-MODE* old-setting))
	)


;; DISPLAY-ALL-MAPS
;; input: none
;; return: none. Displays every map in maps.scm
;; NOTE: your AI should not call this procedure
(define (display-all-maps)
	(let ((orig *SPECIFIC-MAP*)
	      (old-setting *MAP-SELECTION-MODE*))
		(newline)
		(for-each
			(lambda (x)
				(begin
					(set! *SPECIFIC-MAP* (car x))
					(display+ "Map: " (car x))
					(play-game 'display 'board)
					(newline)
					(display "Hit Enter to continue.")
					(flush-output) 
				    (read-line)
				    (newline)
					))
			(mapList))
		(set! *SPECIFIC-MAP* orig)
		(set! *MAP-SELECTION-MODE* old-setting)
		'done))
  
;;;===============================;;;
;;;  CELL INFORMATION PROCEDURES  ;;;
;;;===============================;;;

;; GET-CELL
;; input: a cell number and the board
;; return: the data for the specified cell number
;; NOTE: the cell number is stripped from the data
(define (get-cell number board)
  (if (null? board) 
      #f
      (if (eq? (caar board) number)
	  (cdar board)
	  (get-cell number (cdr board)))))


;; GET-ATTACK-COUNT
;; input: a cell number and the board
;; return: how many units there will be if the specified cell attacks this turn
(define (get-attack-count cell-number board)
  (inexact->exact (ceiling (* (get-enrage-value *CURRENT-TURN*) 
			      (/ (list-ref (get-cell cell-number board) 4) 2))))
  )

;; GET-REMAINING-CELL-COUNT
;; input: a cell number and the board
;; return: how many units will remain if the specified cell attacks this turn
(define (get-remaining-count cell-number board)
  (inexact->exact (floor (/ (list-ref (get-cell cell-number board) 4) 2)))
  )

;; GET-OWNER
;; input: a cell number and the board
;; return: the owner of the specified cell
(define (get-owner cell-number board)
  (caddr (get-cell cell-number board))
  )

;; DISTANCE
;; input: two cell numbers and the board
;; return: the euclidian distance between those two cells
(define (distance cell-one-number cell-two-number board)
  (let ((c1 (get-cell cell-one-number board))
	(c2 (get-cell cell-two-number board)))
    
    (sqrt (+ (square (- (car c2) (car c1))) 
	     (square (- (cadr c2) (cadr c1)))))
    )
  )

;; GET-CELL-COORDINATES
;; input: a cell number and the board
;; return: the x y coordinates of the cell in a list
(define (get-cell-coordinates cell-number board)
  (let ((cell (get-cell cell-number board)))

    (list (car cell) (cadr cell)))
  )

;; ISCLOSER?
;; input: a start cell number, two cell numbers and the board
;; return: true if start cell is closer to cell 1
;;         false if start cell is closer to cell 2
(define (iscloser? start-cell-number cell-1-number cell-2-number board)
  (< (distance start-cell-number cell-1-number board) 
     (distance start-cell-number cell-2-number board))
  )
	
;;;====================;;;
;;;  Move Procedures   ;;;
;;;====================;;;

;; MAKE-MOVE
;; input: the origin cell number and the destination cell number
;; return: a move object in proper format - ('move origin destination)
(define (make-move origin-number destination-number)
  (list 'move origin-number destination-number)
  )

;; MOVE?
;; input: any object
;; return: true if the object is a move object
;;         false if the object is not a move object
(define (move? move)
  (and (list? move)
       (not (null? move))
       (eq? (car move) 'move))
  )

;; GET-MOVE-ORIGIN
;; input: a move object
;; return: the cell number of the cell from which the specified move originated
;; NOTE: will error with incorrect input
(define (get-move-origin move)
  (if (not (move? move))
      (error "GET-MOVE-ORIGIN - not a move object: " move)
      (cadr move))
  )

;; GET-MOVE-DESTINATION
;; input: a move object
;; return: the cell number of the cell to which the specified move is destined
(define (get-move-destination move)
  (if (not (move? move))
      (error "GET-MOVE-DESTINATION - not a move object: " move)
      (caddr move))
  )

;;;===========================;;;
;;;  Queued-Move Procedures   ;;;
;;;===========================;;;

;; MOVE->QUEUED-MOVE
;; input: two cell numbers (the origin and the destination) and the board
;; return: a queued-move object in proper format, shown below
;; ('queued-move distance origin destination unit-count owner-symbol)
(define (move->queued-move origin destination board)
  (if (= origin destination)
      (error "MOVE->QUEUED-MOVE - origin cannot be equal to desitination")
      (list 'queued-move 
	    (distance origin destination board) origin destination 
	    (get-attack-count origin board) (get-owner origin board)
	    )
      )
  )

;; QUEUED-MOVE?
;; input: an object
;; return: true of the object is a queued-move object
;;         false if the object is not a queued-move object
(define (queued-move? move)
  (and (list? move)
       (not (null? move))
       (eq? (car move) 'queued-move))
  )

;; GET-DISTANCE-QUEUED
;; input: a queued-move object
;; return: the distance between the current position of the move and its 
;;         destination cell
(define (get-distance-queued queued-move)
  (list-ref queued-move 1)
  )

;; GET-TIME-QUEUED
;; input: a queued-move object
;; return: the number of turns before this queued-move is executed
(define (get-time-queued queued-move)
  (ceiling (/ (list-ref queued-move 1)
	      *MOVE-SPEED*))
  )

;; GET-ORIGIN-QUEUED
;; input: a queued-move object
;; return: the cell number of the cell from which this move originated
(define (get-origin-queued queued-move)
  (list-ref queued-move 2)
  )

;; GET-DESTINATION-QUEUED
;; input: a queued-move object
;; return: the cell number of the cell for which this move is destined
(define (get-destination-queued queued-move)
  (list-ref queued-move 3)
  )

;; UNIT-COUNT-QUEUED
;; input: a queued-move object
;; return: the total number of units in the specified queued-move
;; NOTE: this number may be lowered upon arrival if this move is a reinforcement
(define (unit-count-queued queued-move)
  (list-ref queued-move 4)
  )

;; GET-OWNER-QUEUED
;; input: a queued-move object
;; return: the player-symbol of the owner of this queued-move
(define (get-owner-queued queued-move)
  (list-ref queued-move 5)
  )

;;;====================;;;
;;;  Queue Procedures  ;;;
;;;====================;;;

;; MAKE-QUEUE
;; input: none
;; return: an empty queue in proper format - ('queue)
;; NOTE: when moves are added to the queue, it will look like this:
;;('queue ('queued-move distance origin destination unit-count owner-symbol)...)
(define (make-queue)
  (cons 'queue '())
  )

;; INSERT-QUEUE
;; input: a queued-move object and a queue object
;; return: none. The specified queue is modified in place with mutators
;; NOTE: the specified queued-move object is added to the queue such that the
;;       queue remains sorted based on time until the move is executed
(define (insert-queue queued-move queue)
  (if (null? (cdr queue))
      (set-cdr! queue (cons queued-move '())) 
      (let ((front (cadr queue))) 
	(if (< (cadr queued-move) (cadr front))
	    (set-cdr! queue (cons queued-move (cdr queue)))
	    (insert-queue queued-move (cdr queue)))))
  )

;; REMOVE-FRONT
;; input: a queue object
;; return: none. The specified queue is modified in place with mutators.
;; NOTE: the first item is deleted from the queue
(define (remove-front queue)
  (if (null? (cdr queue)) 
      (error "Queue is already empty, cannot remove front")
      (set-cdr! queue (cddr queue)))
  )

;; CHECK-FRONT
;; input: a queue object
;; return: the first item of the queue. Does not delete the first item
(define (check-front queue)
  (if (null? (cdr queue))
      #f
      (cadr queue))
  )
