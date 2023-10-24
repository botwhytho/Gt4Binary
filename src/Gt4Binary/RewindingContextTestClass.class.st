Class {
	#name : #RewindingContextTestClass,
	#superclass : #Object,
	#category : #Gt4Binary
}

{ #category : #accessing }
RewindingContextTestClass class >> ensureSudo [
	thisContext return.
	self inform: 'This code doesn''t get reached.'.
	^ self new
]

{ #category : #accessing }
RewindingContextTestClass class >> ensureSudo2 [
	thisContext return.
	self inform: 'This code doesn''t get reached.'.
	^ self new
]

{ #category : #accessing }
RewindingContextTestClass class >> ensureSudo2: anArray [
	anArray first
		ifNil: [ anArray at: 1 put: "Continuation current" thisContext jump ].
	self inform: 'This code doesn''t get reached.'.
	^ self new
]

{ #category : #accessing }
RewindingContextTestClass class >> ensureSudo3: anArray [
	anArray first
		ifNil: [ | aProcess |
			aProcess := Process
					forContext: thisContext
					priority: Processor activePriority.
			anArray at: 1 put: aProcess.
			aProcess suspend ].
	self inform: 'This code doesn''t get reached.'.
	^ self new
]

{ #category : #accessing }
RewindingContextTestClass class >> ensureSudo4: anArray [
	anArray first
		ifNil: [ anArray at: 1 put: false.
			[ anArray first ] whileFalse: [ Processor yield ] ].
	self inform: 'This code doesn''t get reached.'.
	^ self new
]

{ #category : #accessing }
RewindingContextTestClass class >> ensureSudo5: aPendingPromise [
	aPendingPromise  wait.
	aPendingPromise isRejected ifTrue: [ thisContext return ].
	self inform: 'This code doesn''t get reached.'.
	^ self new
]

{ #category : #accessing }
RewindingContextTestClass class >> ensureSudo6: anArray [
	anArray first
		ifNil: [ anArray at: 1 put: thisContext copyStack.
			thisContext return ].
	anArray first ifNil: [ thisContext return ].
	self inform: 'This code doesn''t get reached.'.
	^ self new
]

{ #category : #accessing }
RewindingContextTestClass class >> ensureSudo7: aValueHolder [
	^ self
		performAction: {aValueHolder.
				thisContext}
]

{ #category : #accessing }
RewindingContextTestClass class >> ensureSudo8: aValueHolder [
	| aContext |
	aContext := thisContext stack
			detect: [ :each | (each method isKindOf: CompiledCode) and: [ each method selector = #DoIt ] ].
			self halt.
	aValueHolder contents
		ifNil: [ aValueHolder contents: aContext copyStack.
			aContext return ].
	self inform: 'This code doesn''t get reached.'.
	^ self new
]

{ #category : #accessing }
RewindingContextTestClass class >> performAction [
]

{ #category : #accessing }
RewindingContextTestClass class >> performAction: someArgs [
	| aValueHolder aContext |
	aValueHolder := someArgs first	.
	aContext := someArgs second.
	"Below we would test seeing if env var is set."	
	aValueHolder contents
		ifNil: [ aValueHolder contents: aContext copyStack.
			thisContext return ].
	self inform: 'This code doesn''t get reached.'.
	^ self new
]

{ #category : #accessing }
RewindingContextTestClass >> ensureSudo [
	self halt.
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

{ #category : #accessing }
RewindingContextTestClass >> reached [
	self inform: 'Will this instance code get triggered.'
]
