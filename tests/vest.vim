"
" vest - utility to test vim scripts
"

let s:test_name='default'

function! Vest_run(tests)
	try
		for Test in a:tests
			call Test()
		endfor
		echo "All done."
	catch
		echo "Test " . s:test_name . " failed."
		echo v:exception
	endtry
endfunction

function Vest_test_name(name)
	let s:test_name=a:name
endfunction

function Vest_assert_equal(x, y)
	if a:x != a:y
		throw "Assert failed: " . a:x . " = " . a:y
	endif
endfunction

