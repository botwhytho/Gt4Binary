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
		ifAbsent: [ context := thisContext stack
					detect: [ :each | (each method isKindOf: CompiledCode) and: [ each method selector = #DoIt ] ].
			BlSpace
				spaceWithId: GtWorld defaultId
				do: [ :aSpace | 
					aSpace
						showNotification: (GtNotificationSudoPasswordEvent new context: context copyStack) ].
			context return ].
	^ self new
]

{ #category : #'*Gt4Binary' }
GtExternalProcessBuilder >> tempTestMethod [
	self inform: 'A method in cascade was triggered.'
]

{ #category : #'*Gt4Binary' }
GtExternalProcessBuilder >> tempTestMethod2 [
	self inform: 'Another method in cascade was triggered.'
]

{ #category : #'*Gt4Binary' }
GtExternalProcessBuilder >> withOSLineEndings [
	| currentArguments |
	self arguments
		ifNotEmpty: [ currentArguments := self arguments deepCopy.
			self arguments removeAll.
			self args: (currentArguments collect: #withOSLineEndings) ]
]
