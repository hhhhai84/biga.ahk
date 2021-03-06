times(param_n,param_iteratee:="__identity") {
	if (!this.isNumber(param_n)) {
		this._internal_ThrowException()
	}

	; prepare
	l_array := []

	; create
	loop, % param_n {
		l_array.push(param_iteratee.call(A_Index))
	}
	return l_array
}


; tests
assert.test(A.times(4, A.constant(0)), [0, 0, 0, 0])


; omit
