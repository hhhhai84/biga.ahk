startsWith(param_string,param_needle,param_fromIndex:= 1) {
	if (!this.isString(param_string) || !this.isString(param_needle) || !this.isNumber(param_fromIndex)) {
		this._internal_ThrowException()
	}

	; create
	l_startString := SubStr(param_string, param_fromIndex, StrLen(param_needle))
	; check if substring matches
	if (this.isEqual(l_startString, param_needle)) {
		return true
	}
	return false
}


; tests
assert.true(A.startsWith("abc", "a"))
assert.false(A.startsWith("abc", "b"))
assert.true(A.startsWith("abc", "b", 2))
StringCaseSense, On
assert.false(A.startsWith("abc", "A"))


; omit
; set caseSensitive back to false
StringCaseSense, Off

; make sure comment detection works
assert.true(A.startsWith("; String", ";"))
assert.true(A.startsWith("; String", "; "))
assert.true(A.startsWith("; String", "; String"))
