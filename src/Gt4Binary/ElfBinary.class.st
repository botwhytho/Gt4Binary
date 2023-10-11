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
	^ dependencies
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
ElfBinary >> libraryDependents [
	^ libraryDependents
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
