(import [os [popen]]
	[os.path [exists]]
	[sys]
	[re])

(defun get-font-metadata [ fontfile]
  (if (not (exists fontfile))
    (kwapply (print "Please give existent font file")
	     {"file" sys.stderr}))
  (let [[cmd (.format "/usr/bin/otfinfo -i {}" fontfile)]
	[fd (kwapply (popen cmd) {"mode" "r"})]
	[regexp (.compile re "([a-zA-Z\s]+):\s*(.*)")]
	[metadict {}]
	[copyright-text []]]
    (foreach [line (.readlines fd)]
      (let [[regmatch (.match regexp line)]]
	(if (!= regmatch None)	  
	  (assoc metadict (.group regmatch 1)
		 (.group regmatch 2))	  
	  (.append copyright-text line))))
    (if (in "Copyright" metadict)
	(assoc metadict "Copyright"
	       (.format "{}\n{}"
			(get metadict "Copyright")
			(.join "" copyright-text))))
    metadict))
