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

    ;; Returns a random-element from a list.
    (define (random-element lst)
      (list-ref lst (random (length lst))))
    
	;; Makes a random move
    (define (make-random-move player board)
		(let ((my-cells (get-cell-list player board)))
			(list (make-move (car (random-element my-cells)) 
				(car (random-element board))))))


	


    ;;====================;;
    ;; Get-Move Procedure ;;
    ;;===============================================================;;
    ;; This is the procedure called by dots++.scm to get your move.  ;;
    ;; Returns a line-position object.
    ;;===============================================================;;

	;; Main procedure
    (define (get-move player queue board)
      (make-random-move player board))


    ;; Return get-move procedure
    get-move

    )) ;; End of player-procedure
    
