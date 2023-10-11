Class {
	#name : #ElfBinary,
	#superclass : #Object,
	#instVars : [
		'name',
		'path',
		'dependencies',
		'rawData',
		'libraryDependents'
	],
	#category : #Gt4Binary
}

{ #category : #accessing }
ElfBinary >> calculateDependencies [
	| parsed process |
	process := GtSubprocessWithInMemoryOutput new
			shellCommand: 'sh';
			arguments: {'-c'.
					'ldd ' , self path asAbsolute pathString};
			runAndWait.
	parsed := process stdout lines
			collect: [ :each | MyEnvironment lddDependencyParser parse: each ]
			thenSelect: #isArray.
	parsed
		do: [ :each | 
			| aFileReference |
			aFileReference := each second asFileReference.
			SystemBinaryRegistry default registry
				at: aFileReference basename
				ifAbsentPut: (ElfBinary new
						name: aFileReference basename;
						path: aFileReference;
						rawData: each) ].
	self
		dependencies: (self getDirectDependenciesFor
				collect: [ :each | 
					SystemBinaryRegistry default registry
						at: each
						ifAbsent: [ ElfBinary new
								name: each;
								path: 'Unresolved' ] ])
]

{ #category : #accessing }
ElfBinary >> dependencies [
	^ dependencies ifNil: [ dependencies := OrderedCollection new ]
]

{ #category : #accessing }
ElfBinary >> dependencies: anObject [
	dependencies := anObject
]

{ #category : #accessing }
ElfBinary >> getDirectDependenciesFor [
	| process |
	process := GtSubprocessWithInMemoryOutput new
			shellCommand: 'sh';
			arguments: {'-c'.
					'objdump -x ' , self path asAbsolute pathString};
			runAndWait.
	^ process stdout lines
		select: [ :each | each includesSubstring: 'NEEDED' ]
		thenCollect: [ :each | (([ :c | c isSeparator ] split: each) reject: #isEmpty) second trimBoth ]
]

{ #category : #accessing }
ElfBinary >> gtDependencyBuilderFor: aView withPackages: somePackages title: aTitle andPriority: aPriority [
	^ aView mondrian
		title: aTitle;
		priority: aPriority;
		painting: [ :aMondrian | 
			aMondrian nodes
				stencil: [ :each | 
					BrLabel new
						aptitude: BrGlamorousLabelAptitude;
						text: ((each name
								in: [ :aString | 
									(each libraryDependents isEmpty and: [ each ~= self ])
										ifTrue: [ aString , ' (' ", each dependencyType" , ')' ]
										ifFalse: [ aString ] ]) asRopedText
								in: [ :text | 
									each = self ifTrue: [ text foreground: Color blue ].
									text ]) ];
				with: somePackages.
			aMondrian edges
				fromRightCenter;
				toLeftCenter;
				stencil: [ :aForeignKey :fromElement :toElement | BlSigmoidElement new border: (BlBorder paint: (Color gray alpha: 0.5) width: 2) ];
				connectToAll: [ :each | each dependencies difference: each libraryDependents ].
			aMondrian layout horizontalDominanceTree
				levelDistance: 250;
				nodeDistance: 50;
				treesDistance: 75 ]
]

{ #category : #view }
ElfBinary >> gtNeighborsFor: aView [
	<gtView>
	^ self
		gtDependencyBuilderFor: aView
		withPackages: {self} , "self libraryDependents ," self dependencies
		title: 'Direct Neighbors'
		andPriority: 2
]

{ #category : #accessing }
ElfBinary >> libraryDependents [
	^ libraryDependents ifNil: [ libraryDependents := OrderedCollection new ]
]

{ #category : #accessing }
ElfBinary >> libraryDependents: anObject [
	libraryDependents := anObject
]

{ #category : #accessing }
ElfBinary >> name [
	^ name
]

{ #category : #accessing }
ElfBinary >> name: anObject [
	name := anObject
]

{ #category : #accessing }
ElfBinary >> path [
	^ path
]

{ #category : #accessing }
ElfBinary >> path: anObject [
	path := anObject
]

{ #category : #accessing }
ElfBinary >> rawData [
	^ rawData
]

{ #category : #accessing }
ElfBinary >> rawData: anObject [
	rawData := anObject
]
