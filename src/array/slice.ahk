slice(param_array,param_start:=1,param_end:=0) {
	if (!this.isNumber(param_start)) {
		this._internal_ThrowException()
	}
	if (!this.isNumber(param_end)) {
		this._internal_ThrowException()
	}

	; defaults
	if (this.isString(param_array)) {
		param_array := strSplit(param_array)
	}
	if (param_end == 0) {
		param_end := param_array.Count()
	}

	; prepare
	l_array := []

	; create
	for Key, Value in param_array {
		if (A_Index >= param_start && A_Index <= param_end) {
			l_array.push(Value)
		}
	}
	return l_array
}


; tests
assert.test(A.slice([1, 2, 3], 1, 2), [1, 2])
assert.test(A.slice([1, 2, 3], 1), [1, 2, 3])
assert.test(A.slice([1, 2, 3], 5), [])
assert.test(A.slice("fred"), ["f", "r", "e", "d"])
assert.test(A.slice(100), ["1", "0", "0"])


; omit
