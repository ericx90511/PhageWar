;;;; CSci 1901 Project - Fall 2013
;;;; PhageWars++ Player AI

;;;======================;;;
;;;  SUBMISSION DETAILS  ;;;
;;;======================;;;

;; List both partners' information below.
;; Leave the second list blank if you worked alone.
(define authors 
  '((
     "John Doe"   ;; Author 1 Name
     "doe1234"   ;; Author 1 X500
     "8675309"   ;; Author 1 ID
     "1"   ;; Author 1 Section
     )
    (
     ""   ;; Author 2 Name
     ""   ;; Author 2 X500
     ""   ;; Author 2 ID
     ""   ;; Author 2 Section
     )))

;; CSELabs Machine Tested On: 
;;

;;(cell#, row, column, player, multiplier, units)

;;;====================;;;
;;;  Player-Procedure  ;;;
;;;====================;;;

(define player-procedure
  (let () 

    ;;===================;;
    ;; Helper Procedures ;;
    ;;===============================================================;;
    ;; Include procedures used by get-move that are not available in ;;
    ;;  the util.scm or help.scm file.                               ;;
    ;; Note: PhageWars++.scm loads util.scm and help.scm , so you do ;;
    ;;  not need to load it from this file.                          ;;
    ;; You also have access to the constants defined inside of       ;;
    ;;  PhageWars++.scm - Constants are wrapped in asterisks.        ;;
    ;;===============================================================;;

    (define (enemy-cell-list player board) (get-cell-list (other-player player) board))
    (define (enemy-cell-number-list player board) (get-cell-number-list (other-player player) board))
    (define (my-cell-list player board) (get-cell-list player board))
    (define (my-cell-number-list player board) (get-cell-number-list player board))




    ;; Returns a random-element from a list.
    (define (random-element lst)
      (list-ref lst (random (length lst))))
    
	;; Makes a random move
    (define (make-random-move player board)
		(let ((my-cells (get-cell-list player board)))
			(list (make-move (car (random-element my-cells)) 
				(car (random-element board))))))
    
    ;; defines an non-move
    (define (no-move)
      (list))
 

    ;; finds closest opponent cell to designated cell
    (define (closest desig-cell-list desig-cell board)
      (define (helper cell-list cell)
        (if (null? cell-list)
            cell
            (if (< (distance desig-cell (car cell-list) board) (distance desig-cell cell board))
                (helper (cdr cell-list) (car cell-list))
                (helper (cdr cell-list) cell))))
      (helper desig-cell-list 0))
    


    ;; short term solution
    (define (attack-cell-1 player board)
      (let  ((their-guy (caar (get-cell-list (other-player player) board))) 
	     (my-guy (caar (get-cell-list player board))))
      (list (make-move my-guy their-guy))))


    ;; defines map to iterate over my-cells and return a list of moves
    (define (move-map my-cells board)
      (if (null? my-cells)
	  ()
	  (cons (move-proc (car my-cells) board) (move-map (cdr my-cells) board))))

    ;; defines a procedure to take in game-state (board) and return a move for cell
    (define (move-proc cell board)
      (cond ((equal? 'aggressive (state board)) (aggressive cell))
	    ((equal? 'conservative (state board)) (conservative cell))
	    ((equal? 'losing (state board)) (losing-strat cell))
	    ((equal? 'winning (state board)) (winning-strat cell))
	    ((equal? 'all-but-one (state board)) (final-blow cell))
	    ((equal? 'unknown (state board)) (default cell))
	    (else (defensive cell)))
    )




    (define (neutral-left? board)
      (define (neutral? cell) 
	(equal? (list-ref cell 3) 'N))
      (not (null? (filter neutral? board))))

    ;; describes state of board and returns symbol to describe desired move category
    (define (state board)
      (cond ((and (not (neutral-left?)) (= 1 (length enemy-cell-list))) 'all-but-one)
	    ((
    
    )

    (define (losing-strat cell)
      ;;code for losing strat
      "hello"
    )

    (define (winning-strat cell)
      ;; code to implement strategy when we're winning
       "hello"
    )

    (define (final-blow cell)
      ;; code to deliver final blow to struggling enemy 
      "hello"
    )

    (define (defensive cell)
     (make-move (car cell) (car cell))
    )

    ;; 

    ;;====================;;
    ;; Get-Move Procedure ;;
    ;;===============================================================;;
    ;; This is the procedure called by dots++.scm to get your move.  ;;
    ;; Returns a line-position object.
    ;;===============================================================;;

	;; Main procedure
    (define (get-move player queue board)
      ;(attack-cell-1 player board))
      ;; (if (neutral-left? board)
      ;; 	  (make-random-move player board) 
      ;; 	  (list)))
      (make-move (random-element (my-cell-number-list player board)) (closest (enemy-cell-number-list player board) (car (my-cell-number-list player board)) board))) 

    ;; Return get-move procedure
    get-move

    )) ;; End of player-procedure
    
