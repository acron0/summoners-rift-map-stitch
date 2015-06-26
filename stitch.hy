;;
(import [shutil])
(import [os])
(import [PIL [Image]])
;;
(require hy.contrib.anaphoric)
(require hy.contrib.loop)
;;

;;
(def frag-dir "fragments")
(def os-path (. os path))
;;

(defn int-tuple-to-filename [tup]
	(.join os-path frag-dir (.format "{}_{}.png" (first tup) (second tup))))

(defn filename-to-int-tuple [filename]
	(-> 
		(int it) 
		(ap-map (.split (.replace filename ".png" "") "_")) 
		list 
		tuple))

;; return the height of the row
(defn paste-row [img row ncols coll-h-offset]
	(loop [[col 0] [accw 0] [h 0]] 
		(if (<= col ncols)
	    	(let [[img2 (.open Image (int-tuple-to-filename (, col row)))]
	    	      [incrw (first img2.size)]
	    	      [h (- (second img.size) (second img2.size) coll-h-offset)]]	
	    	      (.paste img img2 (, accw h))
			(recur (inc col) (+ accw incrw) (second img2.size))))
		h))

(defmain [&rest args]

	;; count rows and cols
	(def files    (.listdir os frag-dir))
	(def fileints (list (ap-map (filename-to-int-tuple it) files)))
	(def ncols    (-> (first it) (ap-map fileints) distinct list sorted last))
	(def nrows    (-> (second it) (ap-map fileints) distinct list sorted last))

	;; w
	(def w (loop [[col 0] [acc 0]] 
		(if (<= col ncols)	
			(recur (inc col) (+ acc (second (. (.open Image (int-tuple-to-filename (, col 0))) size)))))
		acc))

    ;; h
	(def h (loop [[row 0] [acc 0]] 
		(if (<= row nrows)	
			(recur (inc row) (+ acc (second (. (.open Image (int-tuple-to-filename (, 0 row))) size)))))
		acc))

    ;; new img
	(def new-img (.new Image "RGB" (, w h) "magenta"))	

    ;; loop each row
	(loop [[row 0] [acch 0]] 
		(if (<= row nrows)
			(let [[incrh (paste-row new-img row ncols acch)]]
				(recur (inc row) (+ acch incrh)))))


	(.save new-img "composite.png")
	(print "Done."))