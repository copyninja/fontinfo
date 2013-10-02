(import [subprocess [check_output]]
	[os.path [exists]]
	[sys]
	[re])

(defun font-exists? [fontfile]
  "Predicate for checking existence of `fontfile`. Prints a non
  existent statement and returns False if file is not physically
  present, otherwise returns True"
  (if (not (exists fontfile))
    (do
     (kwapply (print "Please give existent font file")
	      {"file" sys.stderr})
     False)
    True))

(defun get-font-metadata [ fontfile]
  "Given the `fontfile` function checks for its existence then runs the
  otfinfo tool from lcdf-typetools package to extract metadata
  information and returns the parsed dict.
  .
  The function possibly raises CalledProcessError on wrong input and
  it should be handled appropriately by caller."
  (if (font-exists? fontfile)
    (let [[output (kwapply (check_output
			    ["/usr/bin/otfinfo" "-i" fontfile])
			   {"universal_newlines" True})]
	  [regexp (.compile re "([a-zA-Z]+\s?[a-zA-Z]+):\s*(.*)")]
	  [metadict {}]
	  [copyright-text []]]
      (foreach [line (.split output "\n")]
	(let [[regmatch (.match regexp line)]]
	  (if (!= regmatch None)
	    (assoc metadict (.group regmatch 1)
		   (.group regmatch 2))
	    (.append copyright-text line))))
      (assoc metadict "Copyright"
	     (.format "{}\n{}" 
		      (get metadict "Copyright")
		      (.join "\n" copyright-text)))
      metadict)
    (.exit sys 2)))

(defun get-font-supported-langs [ fontfile ]
  "Function returns dictionary containing language supported by
  `fontfile`. If non existent file is give function will return
  error.
  .
  The function possibly raises CalledProcessError on wrong input and
  it should be handled by caller appropriately."
  (if (font-exists? fontfile)
    (let [[output (kwapply (check_output
			    ["/usr/bin/otfinfo"
			     "-s" fontfile])
			   {"universal_newlines" True})]
	  [langdict {}]]
      (foreach [line (.split output "\n")]
	(if (> (len (.strip line)) 0)
	  (let [[values (.split line)]]
	    (assoc langdict (.strip (get values 0))
		   (.strip (get values 1))))))
      langdict)
    (.exit sys 2)))
