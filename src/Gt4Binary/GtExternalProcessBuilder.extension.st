Extension { #name : #GtExternalProcessBuilder }

{ #category : #'*Gt4Binary' }
GtExternalProcessBuilder class >> ensureSudoPassword [
	^ self promptForPassword: thisContext
]

{ #category : #'*Gt4Binary' }
GtExternalProcessBuilder class >> promptForPassword: aContext [
	| context |
	OSEnvironment current
		at: 'PASSWORD'
		ifAbsent: [ context := aContext copyStack.
			(BlSpace allSubInstances detect: #isFocused)
				showNotification: (GtNotificationSudoPasswordEvent new context: context).
			thisContext return ].
	^ self new
]

{ #category : #'*Gt4Binary' }
GtExternalProcessBuilder >> withOSLineEndings [
	| currentArguments |
	self arguments
		ifNotEmpty: [ currentArguments := self arguments deepCopy.
			self arguments removeAll.
			self args: (currentArguments collect: #withOSLineEndings) ]
]
