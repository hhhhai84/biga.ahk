This method is like A.find except that it returns the index of the first element predicate returns truthy for instead of the element itself.


## Arguments
array (Array): The array to inspect.

[predicate:=A.identity] (Function): The function invoked per iteration.

[fromIndex:=0] (number): The index to search from.


## Returns
(number): Returns the index of the found element, else -1.
