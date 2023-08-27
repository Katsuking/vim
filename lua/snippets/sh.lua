return {
	-- ask to continue
	s({ trig = "askif" }, {
		t({
			[[read -p "Do you want to continue? (y/n) " answer]],
			'if [[ "$answer" == "y" || "$answer" == "Y" ]]; then',
		}),
		t({ "", [[    ]] }), i(0),
		t({
			"", [[else]],
			'fi',
		}),

	}),

	-- read line by line
	s({ trig = "whileread" }, {
		t({ [[while read -r line; do]], "" }),
		t({ [[    ]] }), i(0),
		t({ "", [[done < "${filename}"]] }),
	}),

	-- read line by line
	s({ trig = "readline" }, {
		t({ [[while read -r line; do]], "" }),
		t({ [[    ]] }), i(0),
		t({ "", [[done < "${filename}"]] }),
	}),

	-- class
	s({ trig = "link" }, {
		t({ [[[]()]] }),
	}),

	-- shebang
	s({ trig = "shebang" }, {
		t({ [[#!/bin/bash]] }),
	}),

	-- comment
	s({ trig = "comment" }, {
		t({ [[########################]] }),
		t({ "", [[# ]] }), i(0),
		t({ "", [[########################]] }),
		t({ "", [[# ]] }),
		t({ "", [[#-----------------------]] }),
	}),

}
