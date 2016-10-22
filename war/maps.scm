;==============================================================================;
;         Computer Science 1901 - Fall 2013 - University of Minnesota        ;
;                             Final Course Project                             ;
;==============================================================================;
;  Maps                                                                        ;
; -------------------                                                          ;
;  Notes:                                                                      ;
;   + This file is loaded by PhageWars++.scm.                                  ;
;   + Your player-procedure does not have access to these files.               ;
;   + They are used only at the beginning of a game.                           ;
;   + You may define your own maps, and are encouraged to do so for            ;
;         comprehensive testing.                                               ;
;   + Do not submit this file.                                                 ;
;==============================================================================;

(define (mapList)

;; Board Format:
;; NOTE: Index should be a value 1 through 9, and there should be no duplicates.
;; Using other values on your boards may cause strange display errors or all-out crashes.
;; Cells must use sequential numbers.  All maps must start at cell 1, and all values from 1 
;; to (length board) must have an entry.  Cell numbers in order are preferred.
;; (define boardName 
;;   (list (index row column owner-symbol income unit-count)
;;     	   (index row column owner-symbol income unit-count) ...etc)
;;   )


;; Queue Format:
;; NOTE: QUEUE WILL BE SORTED BY TURNS-LEFT.  
;;       DO NOT ADD MOVES THAT "COULD NOT HAPPEN" - THIS MAY CRASH THE DISPLAY HANDLER
;; (define queueName
;;	 (list ('queued-move distance origin-cell destination-cell unit-count owner)
;;		   ('queued-move distance origin-cell destination-cell unit-count owner) ..etc...))


;; Map Format:
;; (define mapName
;; 	 (list ('dimensions height width)
;;         ('board boardName)
;;         ('queue initialQueue) ;;Optional, defaults to an initially empty queue
;;         ('speed n) ;;Optional, defaults to 3
;;         ('turn n)  ;;Optional, defaults to 1
;;		   ('enrage initial-value turns-per-increment increment) ;;Optional, defaults to 1.00, .1, 10
;;         ('defender-bonus value) ;;Optional, defaults to 2
;; 		   ('time-limit value-in-seconds) ;; Optional, don't worry about this value
;;  ))



	(define board1 
		(list
			(list 1 1 3 *NEUTRAL-SYMBOL* 3 0) 
			(list 2 2 8 *NEUTRAL-SYMBOL* 3 0) 
			(list 3 3 5 *PLAYER-1-SYMBOL* 4 12)
			(list 4 4 1 *NEUTRAL-SYMBOL* 4 0) 
			(list 5 4 10 *NEUTRAL-SYMBOL* 4 0)
			(list 6 5 6 *PLAYER-2-SYMBOL* 4 12)
			(list 7 6 3 *NEUTRAL-SYMBOL* 3 0)
			(list 8 7 8 *NEUTRAL-SYMBOL* 3 0)
		)
	)
	
	(define map1 
		(list
			(list 'dimensions 7 10)
			(list 'board board1)
			(list 'speed 3)
			)
		)
	
	(define board2
		(list 
			(list 1 1 5 *PLAYER-1-SYMBOL* 5 15)
			(list 2 1 8 *NEUTRAL-SYMBOL* 6 20)
			(list 3 2 3 *NEUTRAL-SYMBOL* 3 0)
			(list 4 3 6 *NEUTRAL-SYMBOL* 3 0)
			(list 5 4 1 *NEUTRAL-SYMBOL* 6 20)
			(list 6 4 4 *PLAYER-2-SYMBOL* 5 15)
		)
	)
	
	(define map2
		(list
			(list 'dimensions 4 8)
			(list 'board board2)
			(list 'speed 2)
			)
		)
		
	(define board3
		(list 
			(list 1 1 1 *PLAYER-1-SYMBOL* 6 15)
			(list 2 2 8 *NEUTRAL-SYMBOL* 3 0)
			(list 3 3 5 *NEUTRAL-SYMBOL* 6 5)
			(list 4 4 7 *NEUTRAL-SYMBOL* 3 0)
			(list 5 5 2 *NEUTRAL-SYMBOL* 3 0)
			(list 6 6 4 *NEUTRAL-SYMBOL* 6 5)
			(list 7 7 1 *NEUTRAL-SYMBOL* 3 0)
			(list 8 8 8 *PLAYER-2-SYMBOL* 6 15)
		)
	)
	
	(define map3
		(list
			(list 'dimensions 8 8)
			(list 'board board3)
			(list 'speed 3)
			(list 'enrage 1 20 .1)
			)
		)
		
	(define board4
		(list 
			(list 1 1 9 *PLAYER-1-SYMBOL* 5 12)
			(list 2 2 1 *NEUTRAL-SYMBOL* 6 0)
			(list 3 2 7 *NEUTRAL-SYMBOL* 3 0)
			(list 4 3 4 *NEUTRAL-SYMBOL* 3 0)
			(list 5 4 4 *NEUTRAL-SYMBOL* 3 0)
			(list 6 5 1 *NEUTRAL-SYMBOL* 6 0)
			(list 7 5 7 *NEUTRAL-SYMBOL* 3 0)
			(list 8 6 9 *PLAYER-2-SYMBOL* 5 12)
		)
	)
	
	(define map4
		(list
			(list 'dimensions 6 9)
			(list 'board board4)
			(list 'speed 3)
			(list 'enrage 1 15 .1)
			)
		)
		
	(define board5
		(list 
			(list 1 1 2 *NEUTRAL-SYMBOL* 5 10)
			(list 2 1 7 *PLAYER-2-SYMBOL* 4 10)
			(list 3 2 4 *NEUTRAL-SYMBOL* 3 0)
			(list 4 3 6 *NEUTRAL-SYMBOL* 3 4)
			(list 5 5 2 *NEUTRAL-SYMBOL* 3 4)
			(list 6 6 4 *NEUTRAL-SYMBOL* 3 0)
			(list 7 7 1 *PLAYER-1-SYMBOL* 4 10)
			(list 8 7 6 *NEUTRAL-SYMBOL* 5 10)
		)
	)
	
	
	
	(define map5
		(list
			(list 'dimensions 7 7)
			(list 'board board5)
			(list 'speed 3)
			)
		)
		
	(define board6
		(list 
			(list 1 1 2 *PLAYER-1-SYMBOL* 6 10)
			(list 2 1 10 *NEUTRAL-SYMBOL* 3 0)
			(list 3 2 6 *NEUTRAL-SYMBOL* 5 0)
			(list 4 2 9 *NEUTRAL-SYMBOL* 3 0)
			(list 5 2 11 *NEUTRAL-SYMBOL* 2 0)
			(list 6 3 1 *NEUTRAL-SYMBOL* 1 0)
			(list 7 4 8 *NEUTRAL-SYMBOL* 4 0)
			(list 8 4 12 *NEUTRAL-SYMBOL* 2 0)
			(list 9 5 1 *NEUTRAL-SYMBOL* 2 0)
			(list 10 5 5 *NEUTRAL-SYMBOL* 4 0)
			(list 11 6 12 *NEUTRAL-SYMBOL* 1 0)
			(list 12 7 2 *NEUTRAL-SYMBOL* 2 0)
			(list 13 7 4 *NEUTRAL-SYMBOL* 3 0)
			(list 14 7 7 *NEUTRAL-SYMBOL* 5 0)
			(list 15 8 3 *NEUTRAL-SYMBOL* 3 0)
			(list 16 8 11 *PLAYER-2-SYMBOL* 6 10)
		)
	)
		
		
	(define map6
		(list
			(list 'dimensions 8 12)
			(list 'board board6)
			(list 'speed 3)
			)
		)
	
	(define board7
	  (list
	   (list 1 1 2 *NEUTRAL-SYMBOL* 5 0)
	   (list 2 1 6 *NEUTRAL-SYMBOL* 3 0)
	   (list 3 1 11 *NEUTRAL-SYMBOL* 3 0)
	   (list 4 3 4 *NEUTRAL-SYMBOL* 4 0)
	   (list 5 4 9 *NEUTRAL-SYMBOL* 4 0)
	   (list 6 4 13 *NEUTRAL-SYMBOL* 3 0)
	   (list 7 5 1 *PLAYER-1-SYMBOL* 5 12)
	   (list 8 5 6 *NEUTRAL-SYMBOL* 3 0)
	   (list 9 7 8 *NEUTRAL-SYMBOL* 3 0)
	   (list 10 7 13 *PLAYER-2-SYMBOL* 5 12)
	   (list 11 8 1 *NEUTRAL-SYMBOL* 3 0)
	   (list 12 8 5 *NEUTRAL-SYMBOL* 4 0)
	   (list 13 9 10 *NEUTRAL-SYMBOL* 4 0)
	   (list 14 11 3 *NEUTRAL-SYMBOL* 3 0)
	   (list 15 11 8 *NEUTRAL-SYMBOL* 3 0)
	   (list 16 11 12 *NEUTRAL-SYMBOL* 5 0)
	   )
	  )
	
	(define map7
	  (list
	   (list 'dimensions 11 13)
	   (list 'board board7)
	   (list 'speed 3)
	   )
	  )


;; Map List:
;; NOTE: If you make a new map, you MUST add it here as well!

	(list
		(cons 'map1 map1)
		(cons 'map2 map2)
		(cons 'map3 map3)
		(cons 'map4 map4)
		(cons 'map5 map5)
		(cons 'map6 map6)
		(cons 'map7 map7)
		;Add new maps here, format (cons name map)
		;Don't forget to add it to the PhageWars++ list as well!
	)
)
