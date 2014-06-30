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

function Vest_assert_equal(result, assert, ...)
	if a:assert.'' != a:result.''
		if a:0 > 0
			let message = a:1
		else
			let message = '{%result} = {%assert}'
		endif
		let message = substitute(message, '{%result}', a:result, 'g')
		let message = substitute(message, '{%assert}', a:assert, 'g')
		throw "Assert failed: " . message
	endif
endfunction

