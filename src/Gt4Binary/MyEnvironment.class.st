Class {
	#name : #MyEnvironment,
	#superclass : #Object,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#instVars : [
		'pathString',
		'path'
	],
	#classVars : [
		'LDDParser'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #Gt4Binary
}

{ #category : #accessing }
MyEnvironment class >> getDependenciesFor: aFileReference [
	| process |
	process := GtSubprocessWithInMemoryOutput new
			shellCommand: 'sh';
			arguments: {'-c'.
					'ldd ' , aFileReference asAbsolute pathString};
			runAndWait.
	^ process stdout lines
]

{ #category : #accessing }
MyEnvironment class >> getDirectDependenciesFor: aFileReference [
	| process |
	process := GtSubprocessWithInMemoryOutput new
			shellCommand: 'sh';
			arguments: {'-c'.
					'objdump -x ' , aFileReference asAbsolute pathString};
			runAndWait.
	^ process stdout lines
		select: [ :each | each includesSubstring: 'NEEDED' ]
		thenCollect: [ :each | (([ :c | c isSeparator ] split: each) reject: #isEmpty) second trimBoth ]
]

{ #category : #accessing }
MyEnvironment class >> gtSummaryFor: aView [
	<gtView>
	<gtClassView>
	^ aView forward
		title: 'Directories in Path';
		priority: -1;
		object: [ self default ];
		view: #gtPathsFor:
]

{ #category : #accessing }
MyEnvironment class >> lddDependencyParser [
	^ LDDParser
		ifNil: [ LDDParser := ('=>' asPParser negate plus flatten trim , '=>' asPParser
					, $( asPParser negate plus flatten trim , $( asPParser
					, $) asPParser negate plus flatten trim , $) asPParser)
					==> [ :t | 
						{t first trimBoth.
							t third trimBoth.
							t fifth trimBoth} ] ]
]

{ #category : #accessing }
MyEnvironment >> gtPathsFor: aView [
	<gtView>
	| dynamicLabel |
	dynamicLabel := [ :aPath | 
		| aStream |
		aStream := AsyncDepthFirstTraversalStream
				root: aPath
				children: [ :each | 
					[ (each isSymlink not and: [ each isDirectory ])
						ifTrue: [ each children
								select: [ :aChild | aChild isDirectory or: [ aChild isBinaryExecutable ] ] ]
						ifFalse: [ #() ] ] on: Error do: [ :ex | ex return: #() ] ].
		BrLabel new
			fitContent;
			aptitude: BrGlamorousLabelAptitude;
			withAsyncSinkDo: [ :anElementSink | 
				anElementSink
					sink: AsyncCounterSink new;
					whenUpdate: [ :aLabel :aCounterSink | aLabel text: aPath pathString , ' (' , aCounterSink count asStringWithCommas , ' binaries)' ];
					forwardStream: (aStream select: [:each| each isDirectory not "and: [each isSymlink not]"]) ] ].
	^ aView explicit
		title: 'Directories in Path';
		priority: -1;
		stencil: [ GtPhlowProtoView new columnedList
				items: self path;
				column: 'Paths (Deduplicated & In the Order they Appear in "${PATH}" variable'
					icon: dynamicLabel
					weight: 1 ]
]

{ #category : #accessing }
MyEnvironment >> initialize [
	super initialize.
	self pathString: (OSEnvironment current at: 'PATH').
	self path: (self splitPath: self pathString)
	
]

{ #category : #accessing }
MyEnvironment >> path [
	^ path
]

{ #category : #accessing }
MyEnvironment >> path: anObject [
	path := anObject
]

{ #category : #accessing }
MyEnvironment >> pathString [
	^ pathString
]

{ #category : #accessing }
MyEnvironment >> pathString: anObject [
	pathString := anObject
]

{ #category : #accessing }
MyEnvironment >> splitPath: aPathString [
	| collection |
	collection := OrderedCollection new.
	((':' split: aPathString) collect: #asFileReference)
		do: [ :each | (collection includes: each) ifFalse: [ collection add: each ] ].
	^ collection
]
