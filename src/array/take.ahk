take(param_array,param_n:=1) {
	if (!this.isNumber(param_n)) {
		this._internal_ThrowException()
	}

	; prepare
	if (isObject(param_array)) {
		param_array := this.clone(param_array)
	}
	if (this.isString(param_array)) {
		param_array := StrSplit(param_array)
	}
	l_array := []

	; create
	loop, % param_n	{
		;continue if requested index is higher than param_array can account for
		if (param_array.Count() < A_Index) {
			continue
		}
		l_array.push(param_array[A_Index])
	}
	; return empty array if empty
	if (l_array.Count() == 0 || param_n == 0) {
		return []
	}
	return l_array
}


; tests
assert.test(A.take([1, 2, 3]), [1])
assert.test(A.take([1, 2, 3], 2), [1, 2])
assert.test(A.take([1, 2, 3], 5), [1, 2, 3])
assert.test(A.take([1, 2, 3], 0), [])
assert.test(A.take("fred"), ["f"])
assert.test(A.take(100), ["1"])
; omit
assert.test(A.take([]), [])
