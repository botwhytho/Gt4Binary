Class {
	#name : #MyEnvironment,
	#superclass : #Object,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#instVars : [
		'pathString',
		'path'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #Gt4Binary
}

{ #category : #accessing }
MyEnvironment >> gtPathsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Directories in Path';
		priority: 10;
		items: self path;
		column: 'Paths'
			text: [ :each | 
				each pathString , ' (' , each allBinaryFiles size asStringWithCommas
					, ' binaries)' ]
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
