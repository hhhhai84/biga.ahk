initial(param_array) {

	; prepare
	if (isObject(param_array)) {
		l_array := this.clone(param_array)
	}
	if (this.isString(param_array)) {
		l_array := StrSplit(param_array)
	}

	; create
	; return empty array if empty
	if (l_array.Count() == 0) {
		return []
	}
	return % this.dropRight(l_array)

}


; tests
assert.test(A.initial([1, 2, 3]), [1, 2])
assert.test(A.initial("fred"), ["f", "r", "e"])
assert.test(A.initial(100), ["1", "0"])


; omit
assert.test(A.initial([]), [])
