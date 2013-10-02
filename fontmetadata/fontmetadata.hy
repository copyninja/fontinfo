(import [subprocess [check_output]]
	[os.path [exists]]
	[sys]
	[re])

(defun get-font-metadata [ fontfile]
  "Given the `fontfile` function checks for its existence then runs the
  otfinfo tool from lcdf-typetools package to extract metadata
  information and returns the parsed dict."
  (if (not (exists fontfile))
    (kwapply (print "Please give existent font file")
	     {"file" sys.stderr}))
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
    metadict))
