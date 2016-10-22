;;;; CSci 1901 Project - Fall 2013
;;;; PhageWars++ Player AI

;;;======================;;;
;;;  SUBMISSION DETAILS  ;;;
;;;======================;;;

;; List both partners' information below.
;; Leave the second list blank if you worked alone.
(define authors 
  '((
     "John McGrory"   ;; Author 1 Name
       ;; Author 1 X500
        ;; Author 1 ID
        ;; Author 1 Section
     )
    (
     "Eric Kang"   ;; Author 2 Name
        ;; Author 2 X500
      ;; Author 2 ID
       ;; Author 2 Section
     )))

;; CSELabs Machine Tested On: 
;; KH1260-10.cselabs




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


;;=============================================================================================;;
;;                          ;procedure for utilities                                           ;;  
;;                                                                                             ;;
;;=============================================================================================;;

    ; Name: random-element. Input: a list. Output: random element, retunrn random number according to size of list
    (define (random-element lst)
      (list-ref lst (random (length lst))))

    ; Name: cell-num. Input: a list. Output: get cell number of a cell
    (define (cell-num lst)
      (list-ref lst 0))
    
    ;Name: max-unit. Input: a list. Output: the max unit
    (define (max-unit lst)
      (if (null? lst)
          -999
          (max (list-ref (car lst) 5) (max-unit (cdr lst)))))

   ; Name: min-unit. Input: a list. Output: the min unit
    (define (min-unit lst)
      (if (null? lst)
          999
          (min (list-ref (car lst) 5) (min-unit (cdr lst)))))

    ; Name: find-max-cell. Input: a list. Output: the max unit cell
    (define (find-max-cell lst)
      (define (helper lst max-unit)
	(cond ((= max-unit (list-ref (car lst) 5)) (car lst))
	      (else (helper (cdr lst) max-unit))))   
      (if (null? lst) '() (helper lst (max-unit lst)))
    )
   
    ; Name: find-min-cell. Input: a list. Output: the min unit cell
    (define (find-min-cell lst)
      (define (helper lst min-unit)
	(cond ((= min-unit (list-ref (car lst) 5)) (car lst))
	      (else (helper (cdr lst) min-unit))))
     (if (null? lst) '() (helper lst (min-unit lst)))
    )
    
    (define (max-lst lst)
      (if (null? lst)
	  -999
	  (max (car lst) (max-lst (cdr lst)))))
    (define (min-lst lst)
      (if (null? lst)
	  999
	  (min (car lst) (min-lst (cdr lst)))))
    
    ; Name: remove-duplicate. Input: a list. Output: a list with duplicates remvoed
    (define (remove-duplicate lst)
      (define (helper lst new-lst)
	(cond ((null? lst) new-lst)
	      ((not (member (car lst) new-lst)) (helper (cdr lst) (cons (car lst) new-lst))) 
	      ((member (car lst) new-lst) (helper (cdr lst) new-lst))
	      (else '())
	))(helper lst '()))

    ; Name: union. Input: two lists. Output: a unioned set
    (define (union set1 set2)
      (cond ((null? set1) set2)
	    (else (cons (car set1) (union (cdr set1) set2)))))
    
    ; Name: super-union. Input: a nested list. Output: a list
    (define (super-union lst)
      (cond ((null? lst) '())
	    ((not (null? lst)) (union (car lst) (super-union (cdr lst))))
	    ))


    ; Name: insertion-sort. Input: a list. Output: a sorted list
    (define (insert x lst)
      (if (null? lst)
	  (list x)
      (let ((y (car lst))
            (ys (cdr lst)))
        (if (<= x y)
            (cons x lst)
            (cons y (insert x ys))))))
 
    (define (insertion-sort lst)
      (if (null? lst)
	  '()
	  (insert (car lst)
		  (insertion-sort (cdr lst)))))

;==================================================================================================================;;
;                                   ;dark procedures!! don't touch them                                             ;;
;==================================================================================================================;;



(define (inside-attacked-cells enemy-attack)
	 (cond ((null? enemy-attack) '())
	       ((not (null? enemy-attack)) (cons (list-ref (car enemy-attack) 3) (inside-attacked-cells (cdr enemy-attack))))
	       (else '())))
    

;;===================================================================================================================;;
;;	                                                                                                             ;;
;;                                           ;Procedure for queue                                                    ;;
;;===================================================================================================================;;
   

    ; Name:get-my-queue-list. Input: queue, player. Output: my-cell-list
    (define (get-my-queue-list queue player)
     (filter (lambda (x) (eq? player (list-ref x 5))) (cdr queue)))

    ; Name:get-enemy-queue-list. Input: queue, player. Output: enemy moving queue list
    (define (get-enemy-queue-list queue player)
      (filter (lambda (x) (eq? (other-player player) (list-ref x 5))) (cdr queue)))

    ; Name:get-queue-number-list (destination). Input: queue. Output: enemy moving queue's destination list
    (define (get-queue-number-list queue)
      (cond ((equal? queue '()) '())
	    (else (cons (get-destination-queued (car queue)) (get-queue-number-list (cdr queue))))))

    ; Name:remove-queue-from-neutral. Input: queue, neutral, board. Output: a neutral cell list we have not sent unit to
    (define (remove-queue-from-neutral queue neutral board)
      (cond ((null? neutral) '())
	    ((null? queue) neutral)
            ((equal? (car queue) (get-owner (car neutral) board)) (remove-queue-from-neutral (cdr queue) (cdr neutral)))
	    (else (remove-queue-from-neutral queue (cdr neutral)))
      )
    )
    ; Name: set-diff. Input: two lists, neutral-cell-list. Output: complement of new-test
    (define (set-diff setA setB neutral-cells)
      (define (helper set1 set2)
	(if (or (null? set1) (null? set2))
	    set2
        (if (= (car set1) (car set2))
	    (helper (cdr set1) (cdr set2))
	    (if (> (car set1) (car set2))
		(cons (car set2) (helper set1 (cdr set2)))
	        (helper (cdr set1) (cdr set2))
		))))
    (if (null? setA)
        neutral-cells
	(if (null? setA)
	    setB
	    (helper setA setB))))
    
    ; Name: diff. Input: two lists, neutral-cells-list. Output:complement of new-test
     (define (diff setA setB neutral-cells)
      (define (helper set1 set2)
	(if (or (null? set1) (null? set2))
	    set2
        (if (= (list-ref (car set1) 3) (list-ref (car set2) 0))
	    (helper (cdr set1) (cdr set2))
	    (if (> (list-ref (car set1) 3) (list-ref (car set2) 0))
		(cons (car set2) (helper set1 (cdr set2)))
	        (helper (cdr set1) (cdr set2))
		))))
    (if (null? setA)
        neutral-cells
	(if (null? setA)
	    setB
	    (helper setA setB))))


;;=======================================================================================================================;;
;;                                                                                                                       ;;
;;                                           ;; Defense procedures                                                       ;;
;;=======================================================================================================================;;

     ; Name: get-des-eny-list. Input: enemy's queue. Output: get-des-eny-list gets a list of enemy's moving queue's destination
     (define (get-des-eny-list lst)
       (if (null? lst) '()
	   (cons (get-destination-queued (car lst)) (get-des-eny-list (cdr lst)))))
     
     ;Name: enemy-attack-queue. Input: queue, player, board. Output:return a list of queue attacking my cells
     (define (enemy-attack-queue queue player board)
	 (cond ((null? queue) '())
	       ((element? (list-ref (car queue) 3) (get-cell-number-list player board)) 
                                                    (cons (car queue) (enemy-attack-queue (cdr queue) player board)))
	       (else (enemy-attack-queue (cdr queue) player board))
	  )
      )
    
    ; Name: "attacked-cells" Input: enemy-attack, my-cells  Output: my attacked cells     
     (define (attacked-cells my-cells atm)
      (cond ((null? atm) '())
	    ((null? my-cells) '())
	    ((equal? (car atm) (list-ref (car my-cells) 0)) (cons (car my-cells) (attacked-cells (cdr my-cells) (cdr atm))))
	    ((> (car atm) (list-ref (car my-cells) 0)) (attacked-cells (cdr my-cells) atm))
	    ((< (car atm) (list-ref (car my-cells) 0)) (attacked-cells my-cells (cdr atm)))
	    (else '())
	    ))

    ; Name: "new-list" Input: cell, cell list. Output: new cell list with the cell removed
     (define (new-list cell cell-list)
	(cond ((or (null? cell) (null? cell-list)) '())
	      ((= (list-ref cell 0) (list-ref (car cell-list) 0)) (cdr cell-list))
	      ((> (list-ref cell 0) (list-ref (car cell-list) 0)) (cons (car cell-list) (new-list cell (cdr cell-list))))
	      (else cell-list)
	)
     )
     
    ; Name: "new-list-num" Input: cell number, cell list. Output: new cell list with the cell removed
      (define (new-list-num cell cell-list)
	(cond ((or (null? cell) (null? cell-list)) '())
	      ((= cell (list-ref (car cell-list) 0)) (cdr cell-list))
	      ((> cell (list-ref (car cell-list) 0)) (cons (car cell-list) (new-list-num cell (cdr cell-list))))
	      (else cell-list)
	)
     )


    ; Name: get-min-cell-dis Input: a nested cell list. Output: pass a single cell and a list get the cell of the list 
    ; that has the min-distance with the single cell
    (define (get-min-cell-dis cell lst board)
      (define (helper cell lst board min-dis min)
	(cond ((null? cell) min)
	      ((null? lst) min)
	      ((< (distance (car (car cell)) (car (car lst)) board) min-dis) 
	       (helper cell (cdr lst) board (distance (car (car cell)) (car (car lst)) board) (car lst)))
	       (else (helper cell (cdr lst) board min-dis min))	
	))(helper cell lst board 999 '()))

    ; Name: cell-get-min-cell-dis. Input: a cell number. Output: pass a single cell's number and a list get the cell of the list
    ; that has the min-distance with the single cell
      (define (cell-get-min-cell-dis cell lst board)
      (define (helper cell lst board min-dis min)
	(cond ((null? cell) min)
	      ((null? lst) min)
	      ((< (distance (car cell) (car (car lst)) board) min-dis) 
	       (helper cell (cdr lst) board (distance (car cell) (car (car lst)) board) (car lst)))
	       (else (helper cell (cdr lst) board min-dis min))	
	))(helper cell lst board 999 '()))

    ; Name: min-cell-number-list. Input: cell-number, cell list, board. Output: a cell in the cell list with min distance to 
    ;the input cell-number
     (define (min-cell-number-list cell lst board)
      (define (helper cell lst board min-dis min)
	(cond ((null? cell) min)
	      ((null? lst) min)
	      ((< (distance cell (car (car lst)) board) min-dis) 
	       (helper cell (cdr lst) board (distance cell (car (car lst)) board) (car lst)))
	       (else (helper cell (cdr lst) board min-dis min))	
	))(helper cell lst board 999 '()))
     
     ;Name: enemy-unit-op  Input: enemy's attack queue, first cell of my attacked cell. Output: enemy unit to the cell
     (define (enemy-unit-op enemy-attack my-attacked-cells)
       (cond ((null? my-attacked-cells) 0)
	     ((null? enemy-attack) 0)
	     ((equal? (list-ref (car enemy-attack) 3) (list-ref (car my-attacked-cells) 0)) 
	      (+ (list-ref (car enemy-attack) 4) (enemy-unit-op (cdr enemy-attack) my-attacked-cells)))
	     ((not (equal? (list-ref (car enemy-attack) 3) (list-ref (car my-attacked-cells) 0)))
	      (+ (enemy-unit-op (cdr enemy-attack) my-attacked-cells)))
	     (else 0)
       ))

     ; Name: new-enemy-unit-op. Input: enemy's attack queue, my-attacked-cells. Output: enemy unit to the cell
       (define (new-enemy-unit-op enemy-attack my-attacked-cells)
       (cond ((null? my-attacked-cells) 0)
	     ((null? enemy-attack) 0)
	     ((equal? (list-ref (car enemy-attack) 3) (list-ref my-attacked-cells 0)) 
	      (+ (list-ref (car enemy-attack) 4) (new-enemy-unit-op (cdr enemy-attack) my-attacked-cells)))
	     ((not (equal? (list-ref (car enemy-attack) 3) (list-ref my-attacked-cells 0)))
	      (+ (new-enemy-unit-op (cdr enemy-attack) my-attacked-cells)))
	     (else 0)
       ))
      
     ; Name: new-defense. Input: defense-cells,my-cells. Output: the new defense-cells
     (define (new-defense defense1 my-cells1)
       (cond ((null? defense1) my-cells1)
	     ((null? my-cells1) '())
	     ((equal? (car defense1) (list-ref (car my-cells1) 0)) (new-defense (cdr defense1) (cdr my-cells1)))
	     ((> (car defense1) (list-ref (car my-cells1) 0)) (cons (car my-cells1) (new-defense defense1 (cdr my-cells1))))
	     ((< (car defense1) (list-ref (car my-cells1) 0)) (new-defense (cdr defense1) my-cells1))
	     (else '())
	     ))
   
     ; Name: new-my-cells. Input: defense-cells, my-cells. Output: my-attacked-cells-list
     (define (new-my-cells-op defense my-cells)
       (cond ((null? defense) my-cells)
	     ((equal? (car defense) (list-ref (car my-cells) 0)) (new-my-cells-op (cdr defense) (cdr my-cells)))
	     ((> (car defense) (list-ref (car my-cells) 0)) (cons (car my-cells) (new-my-cells-op defense (cdr my-cells))))
	     ((< (car defense) (list-ref (car my-cells) 0)) (new-my-cells-op (cdr defense) my-cells))
	     (else '())
	     ))

     ;Name: rest-list. Input: defense-cells. Output: defense-cells number list
     (define (rest-list defense)
       (cond ((null? defense) '())
	     (else (cons (caar defense) (rest-list (cdr defense))))))
   

;;======================================================================================================================;;
;;                                              ;Makes a random move                                                    ;;
;;                                           ;The main procedure for AI                                                 ;;
;;======================================================================================================================;;

    ; Name: make-random-move. Input: relevant elements. Output: the actions
     (define (make-random-move neutral-cells my-cells enemy-cells new-test defense-cells combo-list avail-list board)                 
       (cond 
              ((not (null? defense-cells))
	       (union (map (lambda (x) (cons 'move x)) defense-cells)
		      (attack avail-list combo-list board)
		)
       	       )
	     ((and (null? defense-cells) (not (null? new-test)) 
		   (< (list-ref (get-min-cell-dis avail-list combo-list board) 5) (/ (list-ref (car avail-list) 5) 2)))
     	       (attack avail-list new-test board))
	     ((and (null? defense-cells) (not (null? new-test)))
	      (attack avail-list combo-list board))
       	     ((and (null? defense-cells) (null? new-test))
            	 (attack avail-list combo-list board))
      	     (else '())))


;;=======================================================================================================================;;    
;;                                                                                                                       ;;
;;                                     ; attacck mode                                                                    ;;
;;                                                                                                                       ;;
;;=======================================================================================================================;;

    ; Name: attack. Input: avail-list, combo-list, board. Output: pewpewpew======>>>
    (define (attack avail-list combo-list board)    	    
       (cond ((null? avail-list) '())
	     ((>= (list-ref (get-min-cell-dis avail-list combo-list board) 5) (list-ref (car avail-list) 5))	   
	      (attack (cdr avail-list) combo-list board))
    	     ((not (null? avail-list)) (cons (make-move (caar avail-list) (car (get-min-cell-dis avail-list combo-list board)))
   					    (attack (cdr avail-list) combo-list board)))
	     ))

;;=======================================================================================================================;;
;;                                                                                                                       ;;
;;                                      ; defense mode                                                                   ;; 
;;                                                                                                                       ;;
;;=======================================================================================================================;;

; Name: super-defense. Input: my-cells, my-attacked-cells, enemy-attack, board. Output: make a defense cell list
(define (super-defense my-cells my-attacked-cells enemy-attack board)
  (cond ((null? my-attacked-cells) '())
	((not (null? my-attacked-cells)) (union (defense-fixed my-cells (car my-attacked-cells) enemy-attack board)
						(super-defense 
(new-defense (insertion-sort (remove-duplicate (super-union (defense-fixed my-cells (car my-attacked-cells) enemy-attack board)))) my-cells)
						 (cdr my-attacked-cells) enemy-attack board)))
	))

; Name: filter-out. Input: my-cells, combo-list, board. Output: filter defense list from combo-list
(define (filter-out my-cells combo-list board)
  (cond ((null? my-cells) '())
	((null? combo-list) '())
	((>= (list-ref (get-min-cell-dis my-cells combo-list board) 5) (list-ref (car my-cells) 5))
	 (filter-out (cdr my-cells) combo-list board))
	((< (list-ref (get-min-cell-dis my-cells combo-list board) 5) (list-ref (car my-cells) 5))
	 (cons (car my-cells) (filter-out (cdr my-cells) combo-list board)))
	(else '())))


; Name: gohome. Input: my-cells, my-attacked-cells, enemy-attacck, board. Output: list of dontmove procedure
(define (gohome my-cells my-attacked-cells enemy-attack board)
  (cond ((null? my-attacked-cells) '())
	((not (null? my-attacked-cells)) (union (dontmove (car my-attacked-cells) enemy-attack)
						(gohome my-cells (cdr my-attacked-cells) enemy-attack board)))
	(else '())))

; Name: dontmove. Input: my-attacked-cell enemy-attack. Output: force my-attacked-cell not to attack
(define (dontmove my-attacked-cells enemy-attack)
  (define (helper my-attacked-cells enemy-attack enemy-unit my-unit)
    (cond ((null? my-attacked-cells) '())
	  ((< (new-enemy-unit-op enemy-attack my-attacked-cells) (/ (list-ref my-attacked-cells 5) 2))
	      (list (list (car my-attacked-cells) (car my-attacked-cells)))) 
	   (else '())))
  (helper my-attacked-cells enemy-attack (new-enemy-unit-op enemy-attack my-attacked-cells) (list-ref my-attacked-cells 5)))

; Name: defense-fixed. Input: my-cells, my-attacked-cells, enemy-attack, board. Output: list of defesen cell list
(define (defense-fixed my-cells my-attacked-cells enemy-attack board)
	 (define (helper my-cells my-attacked-cells enemy-unit my-unit)
	   (cond ((null? my-attacked-cells) '())
		 ((null? my-cells) '())
		 ((= (length my-cells) 1) '())
		 ((and (not (null? my-attacked-cells)) (> enemy-unit my-unit)) 
		  (cons (list (car (cell-get-min-cell-dis  my-attacked-cells (new-list-num (car my-attacked-cells) my-cells) board)) 
			      (car my-attacked-cells)) 
			   (helper 
(new-list-num (car my-attacked-cells) (new-list (cell-get-min-cell-dis  my-attacked-cells (new-list-num (car my-attacked-cells) my-cells) board) my-cells))
			   	 my-attacked-cells enemy-unit 
		 (+ (list-ref (cell-get-min-cell-dis  my-attacked-cells (new-list-num (car my-attacked-cells) my-cells) board) 5) my-unit))
		  ) 
		 )
                 ((and (not (null? my-attacked-cells)) (< enemy-unit my-unit)) 
                 '())

		 (else '())
	    ))
            (if (null? my-attacked-cells) '() 
	 (helper my-cells my-attacked-cells (new-enemy-unit-op enemy-attack my-attacked-cells) (- (list-ref my-attacked-cells 5) 2))))

;;=====================================================================================================================;;
;;                                                                                                                     ;;  
;;                                       ; old defense procedure                                                       ;; 
;;                                                                                                                     ;;
;;=====================================================================================================================;;


       (define (defense my-cells my-attacked-cells enemy-attack board)
	 (define (helper my-cells my-attacked-cells enemy-unit my-unit)
	   (cond ((null? my-attacked-cells) '())
		 ((null? my-cells) '())
		 ((= (length my-cells) 1) '())
		 ((and (not (null? my-attacked-cells)) (> enemy-unit my-unit)) 
		  (cons (list (car (get-min-cell-dis  my-attacked-cells (new-list (car my-attacked-cells) my-cells) board)) 
			      (caar my-attacked-cells)) 
			   (helper 
(new-list (car my-attacked-cells) (new-list (get-min-cell-dis  my-attacked-cells (new-list (car my-attacked-cells) my-cells) board) my-cells))
			   	 my-attacked-cells enemy-unit 
		 (+ (list-ref (get-min-cell-dis  my-attacked-cells (new-list (car my-attacked-cells) my-cells) board) 5) my-unit))
			
		  )	
		 )
		 ((and (not (null? my-attacked-cells)) (< enemy-unit my-unit)) '())
		 (else '())
	    ))
	 (if (null? my-attacked-cells) '()
	 (helper my-cells my-attacked-cells (enemy-unit-op enemy-attack my-attacked-cells) (list-ref (car my-attacked-cells) 5))))

;;================================================================================================================================;;
;;                                                                                                                                ;;
;;                                                  ; display procedure                                                           ;;
;;                                                                                                                                ;;
;;================================================================================================================================;;

     ; Name: test. Input: almost everything. Output: display certain element or procedure
     (define (test player queue board neutral-cells my-cells enemy-cells new-test my-queue enemy-queue enemy-attack my-attacked-cells
             defense-cells atm combo-list avail-list new-avail-list) 
            "LOL"
      ;; (display my-cells)(newline)
      ;; (display my-attacked-cells)(newline)
      ;; (display new-avail-list)(newline)
      ;; (display  (make-random-move neutral-cells my-cells enemy-cells new-test defense-cells combo-list avail-list board))(newline)
      )


	;; move                                  
    ;;====================;;                     
    ;; Get-Move Procedure ;;                      
    ;;===============================================================;;
    ;; This is the procedure called by dots++.scm to get your move.  ;;
    ;; Returns a line-position object.                               ;;
    ;;===============================================================;;

	;; Main procedure
     (define (get-move player queue board)
       (define my-cells (get-cell-list player board))
       (define neutral-cells (get-cell-list *NEUTRAL-SYMBOL* board))
       (define enemy-cells (get-cell-list (other-player player) board))
       (define new-test (diff (get-my-queue-list queue player) neutral-cells neutral-cells))
       (define my-queue (get-my-queue-list queue player))
       (define enemy-queue (get-enemy-queue-list queue player))
       (define enemy-attack (enemy-attack-queue enemy-queue player board))
       (define atm (insertion-sort (remove-duplicate (inside-attacked-cells enemy-attack))))
       (define my-attacked-cells (attacked-cells my-cells atm))
       (define defense-cells (super-defense my-cells my-attacked-cells enemy-attack board))
       (define combo-list (union enemy-cells neutral-cells))
       (define avail-list (new-defense (insertion-sort (remove-duplicate (super-union defense-cells))) my-cells))


     ;; (test player queue board neutral-cells my-cells enemy-cells new-test my-queue enemy-queue enemy-attack my-attacked-cells 
     ;;   defense-cells atm combo-list avail-list new-avail-list)

      (make-random-move neutral-cells my-cells enemy-cells new-test defense-cells combo-list avail-list board)
            
     )

    ;; Return get-move procedure
    get-move

    )) ;; End of player-procedure
