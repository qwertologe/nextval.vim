" nextval.vim test script
" by Serpent7776 mail me at: 'foo@gmail.com'=~s/foo/serpent7776/

source vest.vim

let s:snr=matchstr(maparg("<PLUG>nextvalInc"), '^<SNR>\d\+')
if empty(s:snr)
	throw 'nextval plugin is not loaded'
endif

let s:nextval_exec=function(s:snr . "_nextval_exec")
let s:nextval_reset=function(s:snr . "_nextval_reset")
let s:nextbool=function(s:snr . "_nextbool")
let s:nextnum=function(s:snr . "_nextnum")
let s:nextint=function(s:snr . "_nextint")
let s:nexthex=function(s:snr . "_nexthex")

if 'a' == 'A'
	setlocal noignorecase
	let s:ignorecase = 1
endif

function Test_nextval_bool()
	call Vest_test_name('nextval_bool')
	let values={
\               'false': 'true',
\               'FALSE': 'TRUE',
\               'False': 'True',
\               'no': 'yes',
\               'No': 'Yes',
\               'NO': 'YES'
\	}
	for val1 in keys(values)
		let val2=values[val1]
		let r=s:nextbool(val1)
		call Vest_assert_equal(r, val2)
		let r=s:nextbool(val2)
		call Vest_assert_equal(r, val1)
	endfor
endfunction

function Test_nextval_num()
	call Vest_test_name('nextval_num')
	" array of [value, value-decremented, value-incremented]
	let values=[	
\		['2.1', '2.0', '2.2'],
\		['-1.5', '-1.6', '-1.4'],
\		['12.001', '12.000', '12.002'],
\		['7.00', '6.99', '7.01'],
\		['-2.000', '-2.001', '-1.999'],
\		['0.0', '-0.1', '0.1']
\	]
	for val in values
		let r_inc=s:nextnum(val[0], '+')
		let r_dec=s:nextnum(val[0], '-')
		call Vest_assert_equal(r_dec, val[1], "decrementing ".val[0]." returned {%result}; {%assert} expexted")
		call Vest_assert_equal(r_inc, val[2], "incrementing ".val[0]." returned {%result}; {%assert} expexted")
	endfor
endfunction

function Test_nextval_int()
	call Vest_test_name('nextval_int')
	" array of [value, value-decremented, value-incremented]
	let values=[	
\		['1', '0', '2'],
\		['0', '-1', '1']
\	]
	for val in values
		let r_inc=s:nextint(val[0], '+')
		let r_dec=s:nextint(val[0], '-')
		call Vest_assert_equal(r_dec, val[1], "decrementing ".val[0]." returned {%result}; {%assert} expected")
		call Vest_assert_equal(r_inc, val[2], "incrementing ".val[0]." returned {%result}; {%assert} expected")
	endfor
endfunction

function Test_nextval_hex()
	call Vest_test_name('nextval_hex')
	" array of [value, value-decremented, value-incremented, comment]
	let values=[
\		['2b', '2a', '2c'],
\		['0a', '09', '0b'],
\		['0xf9', '0xf8', '0xfa'],
\		['f', 'e', '10'],
\		['5A3', '5A2', '5A4'],
\		['#x2019', '#x2018', '#x201A'],
\		['\x19', '\x18', '\x1A'],
\		['FFh', 'FEh', '100h'],
\		['#9', '#8', '#A'],
\		['16#5A3', '16#5A2', '16#5A4'],
\		['16r51a', '16r519', '16r51b'],
\		['\u0019', '\u0018', '\u001a'],
\		['#16r4a', '#16r49', '#16r4b'],
\		['H5A3', 'H5A2', 'H5A4', 'test for &H5A3'],
\		['0h5A3', '0h5A2', '0h5A4'],
\		['20AD', '20AC', '20AE', 'test for unicode U+20AD'],
\		['$20f', '$20e', '$210'],
\		["H'ABCD'", "H'ABCC'", "H'ABCE'"],
\		['x"FF"', 'x"FE"', 'x"100"'],
\		["8'hFF", "8'hFE", "8'h100"],
\		["#x4a", '#x49', '#x4b'],
\		["X'5A3'", "X'5A2'", "X'5A4'"]
\	]
	for val in values
		let r_inc=s:nexthex(val[0], '+')
		let r_dec=s:nexthex(val[0], '-')
		call Vest_assert_equal(r_dec, val[1], "decrementing ".val[0]." returned {%result}; {%assert} expected")
		call Vest_assert_equal(r_inc, val[2], "incrementing ".val[0]." returned {%result}; {%assert} expected")
	endfor
endfunction

function Test_nextval_exec()
	call Vest_test_name('nextval_exec')
	" array of [value, value-decremented, value-incremented]
	let tests=[
\		['12', '11', '13'],
\		['.5', '.4', '.6'],
\		['0.1em', '0.0em', '0.2em'],
\		['test1', 'test0', 'test2'],
\		['foo4bar', 'foo3bar', 'foo5bar'],
\		['#x2019', '#x2018', '#x201a'],
\		['\x4a', '\x49', '\x4b'],
\		['#a', '#9', '#b'],
\		['16#cc#', '16#cb#', '16#cd#'],
\		['16rcc', '16rcb', '16rcd'],
\		['16#cc', '16#cb', '16#cd'],
\		['\u0019', '\u0018', '\u001a'],
\		['#16rcc', '#16rcb', '#16rcd'],
\		['0ha0', '0h9f', '0ha1'],
\		['$20', '$1f', '$21'],
\		["H'AB'", "H'AA'", "H'AC'"],
\		['x"5f"', 'x"5e"', 'x"60"'],
\		["8'hFF", "8'hFE", "8'h100"],
\		['#x10', '#xf', '#x11'],
\		["'0.1'", "'0.0'", "'0.2'"],
\		["'0.9foo'", "'0.8foo'", "'1.0foo'"],
\		['"0.9foo"', '"0.8foo"', '"1.0foo"'],
\	]
	for val in tests
		call s:nextval_reset()
		let v_inc=s:nextval_exec(val[0], '+')
		let v_dec=s:nextval_exec(val[0], '-')
		call Vest_assert_equal(v_inc, val[2], "incrementing ".val[0]." returned {%result}; {%assert} expected")
		call Vest_assert_equal(v_dec, val[1], "decrementing ".val[0]." returned {%result}; {%assert} expected")
	endfor
endfunction

let s:tests=[
\       function("Test_nextval_bool"),
\       function("Test_nextval_num"),
\       function("Test_nextval_int"),
\       function("Test_nextval_hex"),
\       function("Test_nextval_exec")
\ ]

call Vest_run(s:tests)

if exists('s:ignorecase')
	setlocal ignorecase
endif
