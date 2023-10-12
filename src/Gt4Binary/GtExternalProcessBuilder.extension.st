Extension { #name : #GtExternalProcessBuilder }

{ #category : #'*Gt4Binary' }
GtExternalProcessBuilder >> withOSLineEndings [
	| currentArguments |
	self arguments
		ifNotEmpty: [ currentArguments := self arguments deepCopy.
			self arguments removeAll.
			self args: (currentArguments collect: #withOSLineEndings) ]
]
