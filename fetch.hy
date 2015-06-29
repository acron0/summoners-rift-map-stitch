;;
(import [requests])
(import [shutil])
(import [os])
(import [PIL [Image]])
(import [StringIO [StringIO]])
;;

;;
(def url-format "http://promo.na.leagueoflegends.com/sru-map-assets/5/{}/{}.png")
(def frag-dir "fragments")
(def os-path (. os path))
;;

(defn download-frag [col row]
	(let [[r (->> (.format url-format col row) (.get requests))]
		  [success  (= r.status_code 200)]
		  [image (if success (.open Image (StringIO r.content)) None)]]
		(if success
	   	   (.save image (.join os-path frag-dir (.format "{}_{}.png" col row))))
		success))

(defmain [&rest args]
	;; delete dir and remake
	(if (.isdir os-path frag-dir)
		(.rmtree shutil frag-dir))
	(.mkdir os frag-dir)

	(let [[fails 0]]
		(for [col (iterate inc 0)]
			(for [row (iterate inc 0)]
				(if (download-frag col row)
					(do 
						(print (.format "Downloaded {}/{}..." col row))
						(setv fails 0))
					(do 
						(setv fails (inc fails))
						(break))))
			(do
				(if (>= fails 2)
				(break)))))
	(print "Done. Now run `hy stitch.hy`."))