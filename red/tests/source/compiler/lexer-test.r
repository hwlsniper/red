Rebol [
	Title:   "Red lexer test script"
	Author:  "Peter W A Wood"
	File: 	 %byte-test.reds
	Rights:  "Copyright (C) 2011 Peter W A Wood. All rights reserved."
	License: "BSD-3 - https://github.com/dockimbel/Red/blob/origin/BSD-3-License.txt"
]

;; setup
store-halt: :halt
halt: func [][]
store-print: :print
output: copy "" 
print: func [v] [append output v]
output-contains?: func [text [string!]][to-logic find output text]

store-quiet-mode: system/options/quiet
system/options/quiet: true

do %../../../../quick-test/quick-unit-test.r
do %../../../lexer.r


~~~start-file~~~ "lexer"

	--test-- "lexer-1"
	src: {Red [] 123}
	--assert [[] 123] = lexer/run src
	
	--test-- "lexer-2"
	src: {Red [] aa}
	--assert [[] aa] = lexer/run src
	
	--test-- "lexer-3"
	src: {Red [] 'a}
	--assert [[] 'a] = lexer/run src
	
	--test-- "lexer-4"
	src: {Red [] a:}
	--assert [[] a:] = lexer/run src

	--test-- "lexer-5"
	src: {Red [] :a}
	--assert [[] :a] = lexer/run src

	--test-- "lexer-6"
	src: {Red [] /}
	--assert [[] /] = lexer/run src

	--test-- "lexer-7"
	src: {Red [] /test}
	--assert [[] /test] = lexer/run src

	--test-- "lexer-8"
	src: {Red [] (a)}
	--assert [[] (a)] = lexer/run src

	--test-- "lexer-9"
	src: {Red [] []}
	--assert [[] []] = lexer/run src

	--test-- "lexer-10"
	src: {Red [] "t"}
	--assert [[] "t"] = lexer/run src

	--test-- "lexer-11"
	src: {Red [] #"a"}
	--assert [[] #"a"] = lexer/run src

	--test-- "lexer-12"
	src: {Red [] #a}
	--assert [[] #a] = lexer/run src

	--test-- "lexer-13"
	src: {Red [] #{00}}
	--assert [[] #{00}] = lexer/run src

	--test-- "lexer-14"
	src: {Red [] foo/bar}
	--assert [[] foo/bar] = lexer/run src

	--test-- "lexer-15"
	src: {Red [] 'foo/bar}
	--assert [[] 'foo/bar] = lexer/run src

	--test-- "lexer-16"
	src: {Red [] foo/bar:}
	--assert [[] foo/bar:] = lexer/run src

	
	--test-- "lexer-17"
	src: {
		Red [title: "test"]

		+ - 
		test123
		4 ttt 5655 /4545
		/ // -123 +5
		print /a 'lit-word
		b: (r + 4) test /refinement
		4545 "foo bar" ;-- comment

		#issue
		#{1234}

		#{
		45788956 ;-- test binary comment
		AAFFEEFF
		}

		comment {test

		}
		%foo/bar.red "foo^@^^/bar"

		#"a" #"^^/"	{
	
	test
	^^(45)
	^^(A2)
	^^(00A2)
	^^(20AC)
	^^(024B62)
	}

		either a = b [
			print [ok]
		][
			print [now]
		]

		foo/bar 'foo/bar foo/bar:
		#[none] #[true ] #[false ] 
	}
	
	result: [
		[title: "test"]
		+ -
		test123
		4 ttt 5655 /4545
		/ // -123 5
		print /a 'lit-word
		b: (r + 4) test /refinement
		4545 "foo bar"
		#issue
		#{1234}
		#{45788956AAFFEEFF}
		%foo/bar.red "foo^@^/bar"
		#"a" #"^/" {
^-
^-test
^-E
^-¢
^-¢
^-¬
^-𤭢
^-}
		either a = b [
			print [ok]
		] [
			print [now]
		]
		foo/bar 'foo/bar foo/bar:
		#[none] #[true ] #[false ]  
	]
?? result	
	--assert result = probe lexer/run src


	--test-- "lexer-20"
	  src: {
	    Red[]
	    a: 1
	  }
	--assert [[] a: 1] = lexer/run src

	--test-- "lexer-21"
	  output: copy ""
	  src: {
	    Red[]
	    1: 1
	  }
	  lexer/run src
	--assert output-contains? "*** Syntax Error: Invalid word! value"
	--assert output-contains? "*** line: 2"
	--assert output-contains?  {*** at: "1: 1}
	  
	--test-- "lexer-22"
	  output: copy ""
	  src: {
	    Red/System[]
	    a: 1
	  }
	  lexer/run src
	--assert output-contains? "*** Syntax Error: Invalid Red program"
	--assert output-contains? "*** line: 1"
	--assert output-contains?  "*** at: {/System[]"
	

	  
~~~end-file~~~

;; tidy up
halt: :store-halt
print: :store-print
system/options/quiet: :store-quiet-mode
prin ""

