Extension { #name : #FileReference }

{ #category : #'*Gt4Binary' }
FileReference >> gtDependenciesFor: aView [
	<gtView>
	self isBinaryExecutable ifFalse: [ ^ aView empty ].
	^ aView columnedList
		title: 'Dependencies';
		priority: 2;
		items: [ | lines parsed |
			lines := MyEnvironment getDependenciesFor: self.
			parsed := lines
					collect: [ :each | MyEnvironment lddDependencyParser parse: each ]
					thenSelect: #isArray.
			parsed
				collect: [ :each | 
					| aFileReference |
					aFileReference := each second asFileReference.
					SystemBinaryRegistry default registry
						at: aFileReference basename
						put: aFileReference ] ];
		column: 'Dependencies' text: [ :each | each pathString ]
]

{ #category : #'*Gt4Binary' }
FileReference >> gtDirectDependenciesFor: aView [
	<gtView>
	self isBinaryExecutable ifFalse: [ ^ aView empty ].
	^ aView columnedList
		title: 'Direct Dependencies';
		priority: 1;
		items: [ (MyEnvironment getDirectDependenciesFor: self)
				collect: [ :each | SystemBinaryRegistry default registry at: each ifAbsent: [ each ] ] ];
		column: 'Dependencies'
			text: [ :each | [ each pathString ] on: MessageNotUnderstood do: [ each ] ]
]
