(load "PhageWars++.scm")
(define file "kangx539.scm")
(set! load/suppress-loading-message? #t)
(define (many-tests AIname)
  (+ (apply + (map (lambda (x) (if (eq? x 'p1) 1 (if (eq? x 'p2) 0 0.5)))
       (list (run-tests file AIname 1 'map1)
	     (run-tests file AIname 1 'map2)
	     (run-tests file AIname 1 'map3)
	     (run-tests file AIname 1 'map4)
	     (run-tests file AIname 1 'map5)
	     (run-tests file AIname 1 'map6)
	     (run-tests file AIname 1 'map7))))
  (apply + (map (lambda (x) (if (eq? x 'p2) 1 (if (eq? x 'p1) 0 0.5)))
       (list (run-tests AIname file 1 'map1)
	     (run-tests AIname file 1 'map2)
	     (run-tests AIname file 1 'map3)
	     (run-tests AIname file 1 'map4)
	     (run-tests AIname file 1 'map5)
	     (run-tests AIname file 1 'map6)
	     (run-tests AIname file 1 'map7))))))
;;(display (string-append "Scores," file "," ))
(display (string-append "Scores," file "," (string (many-tests "random")) ","
(string (many-tests "clyde")) ","
(string (many-tests "belkar")) ","
(string (many-tests "scrooge")) ","
(string (many-tests "super186")) ","))
(newline)

(exit)y
