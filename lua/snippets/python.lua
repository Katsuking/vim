return {

	s({ trig = "main" }, {
		t({ [[    def main():]], [[        ]] }), i(0),
		t({ "", [[ if __name__ == "__main__":]] }),
		t({ "", [[    main()]] }),
	}),

	-- class
	s({ trig = "class" }, {
		t({ [[class ]] }), i(0), t({ ':' }),
		t({ "", [[    def __init__(self):]] }),
		t({ "", [[        super().__init__()]] }),
	}),


}
