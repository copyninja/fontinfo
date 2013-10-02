(import [re])

(defun copyright_parse [ license-text ]
  (let [[regexp 
	 (re.compile "(?:copyright|copr\.|\u00a9|\xc2\xa9|\(c\)|\(C\))\s*(.*)")]
	[copyright-holders (regexp.findall license-text)]]
    (set copyright-holders)
    ))
