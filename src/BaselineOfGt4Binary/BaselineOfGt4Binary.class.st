Class {
	#name : #BaselineOfGt4Binary,
	#superclass : #BaselineOf,
	#category : #BaselineOfGt4Binary
}

{ #category : #loading }
BaselineOfGt4Binary class >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'Gt4Binary' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

{ #category : #baseline }
BaselineOfGt4Binary >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'Gt4Binary'
		]
]
