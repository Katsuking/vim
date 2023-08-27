return {

	s({ trig = "sh" }, {
		t({ [[```sh]], "" }),
		i(0),
		t({ "", [[```]] }),
	}),

	s({ trig = "python" }, {
		t({ [[```python]], "" }),
		i(0),
		t({ "", [[```]] }),
	}),

	-- hide/unhide
	s({ trig = "detail" }, {
		t({ [[<details><summary>]] }), i(0),
		t({ [[</summary>]] }),
		t({ "", [[<details>]] }),
	}),



}
