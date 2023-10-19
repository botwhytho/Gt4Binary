Class {
	#name : #RewindingContextTestClass,
	#superclass : #Object,
	#category : #Gt4Binary
}

{ #category : #accessing }
RewindingContextTestClass >> ensureSudo [
	OSEnvironment current
		at: 'PASSWORD'
		ifPresent: [ self inform: 'exists' ]
		ifAbsent: [ | aContext |
			"self halt."
			aContext := thisContext stack
					detect: [ :each | 
						"self halt."
						each receiver class = GtPharoSnippetCoderViewModel
							and: [ #(#doIt #doItAndGo) includes: each selector ] ].
			self inform: aContext receiver class name , '>>' , aContext selector.
			aContext return ].
	self inform: 'Reached.'
]
