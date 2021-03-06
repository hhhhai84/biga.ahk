join(param_array,param_sepatator:=",") {
	if (!isObject(param_array) || isObject(param_sepatator)) {
		this._internal_ThrowException()
	}

	; prepare
	l_array := this.clone(param_array)

	; create
	for l_key, l_value in l_array {
		if (l_key == 1) {
			l_string := "" l_value
			continue
		}
		l_string := l_string param_sepatator l_value
	}
	return l_string
}


; tests
assert.test(A.join(["a", "b", "c"], "~"), "a~b~c")
assert.test(A.join(["a", "b", "c"]), "a,b,c")
