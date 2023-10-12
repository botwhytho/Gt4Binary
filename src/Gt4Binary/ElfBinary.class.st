Class {
	#name : #ElfBinary,
	#superclass : #Object,
	#instVars : [
		'name',
		'path',
		'dependencies',
		'rawData',
		'libraryDependents',
		'eBPFProbes'
	],
	#category : #Gt4Binary
}

{ #category : #accessing }
ElfBinary >> allDependencies [
	^ self withDeepCollect: #dependencies as: Set
]

{ #category : #accessing }
ElfBinary >> calculateDependencies [
	| parsed process |
	self path = 'Unresolved'
		ifTrue: [ self dependencies: #() ]
		ifFalse: [ process := GtSubprocessWithInMemoryOutput new
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
										path: 'Unresolved' ] ]) ]
]

{ #category : #accessing }
ElfBinary >> dependencies [
	^ dependencies
		ifNil: [ self calculateDependencies.
			dependencies ]
]

{ #category : #accessing }
ElfBinary >> dependencies: anObject [
	dependencies := anObject
]

{ #category : #accessing }
ElfBinary >> eBPFProbes [
	^ eBPFProbes ifNil: [ eBPFProbes := Dictionary new ]
]

{ #category : #accessing }
ElfBinary >> eBPFProbes: anObject [
	eBPFProbes := anObject
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

{ #category : #view }
ElfBinary >> gtDependenciesFor: aView [
	<gtView>
	^ self
		gtDependencyBuilderFor: aView
		withPackages: self allDependencies
		title: 'Dependencies'
		andPriority: 4
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
									"(each libraryDependents isEmpty and: [ each ~= self ])
										ifTrue: [ aString , ' (' , each dependencyType , ')' ]
										ifFalse: [ aString ]"
									each path = 'Unresolved'
										ifTrue: [ aString , '(Unresolved)' ]
										ifFalse: [ aString ]	
										 ]) asRopedText
								in: [ :text | 
									each = self ifTrue: [ text foreground: Color blue ].
									text ]) ];
				with: somePackages.
			aMondrian edges
				fromRightCenter;
				toLeftCenter;
				stencil: [ :aForeignKey :fromElement :toElement | BlSigmoidElement new border: (BlBorder paint: (Color gray alpha: 0.5) width: 1) ];
				connectToAll: [ :each | each dependencies difference: each libraryDependents ].
			aMondrian layout horizontalDominanceTree
				levelDistance: 50;
				nodeDistance: 50;
				treesDistance: 50 ]
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

{ #category : #view }
ElfBinary >> gtSummaryFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Summary';
		priority: 6;
		items: self publicFunctions;
		column: 'Public Functions' text: [ :aSymbol | aSymbol at: 'Name' ];
		column: 'Offset' text: [ :aSymbol | aSymbol at: 'Value' ];
		column: 'Size' text: [ :aSymbol | aSymbol at: 'Size' ];
		column: 'Trace'
			icon: [ :aSymbol | 
				BrCheckbox new
					aptitude: BrGlamorousCheckboxAptitude;
					whenCheckedDo: [ :anEvent | 
						anEvent target phlow
							spawnObject: (self eBPFProbes
									at: (aSymbol at: 'Name')
									put: (EBPFProbe new
											binary: self;
											function: (aSymbol at: 'Name');
											enable)) ];
					whenUncheckedDo: [ (self eBPFProbes at: (aSymbol at: 'Name')) disable.
						self
							flag: 'TODO: research if finalizer will cause a double free type of scenario. Probably need to gaurd more around freeing resources outside of Gt.'.
						self eBPFProbes removeKey: (aSymbol at: 'Name') ifAbsent: [  ] ] ]
			weight: 1
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

{ #category : #view }
ElfBinary >> publicFunctions [
	^ {{'Name' -> 'clipboard_get_contents'.
		'Value' -> '0000000000023b10'.
		'Size' -> '000000000000004a'} asDictionary}
]

{ #category : #accessing }
ElfBinary >> rawData [
	^ rawData
]

{ #category : #accessing }
ElfBinary >> rawData: anObject [
	rawData := anObject
]
