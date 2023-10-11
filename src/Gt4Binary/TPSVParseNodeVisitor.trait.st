Trait {
	#name : #TPSVParseNodeVisitor,
	#traits : 'TSmaCCParseNodeVisitor',
	#classTraits : 'TSmaCCParseNodeVisitor classTrait',
	#category : #'Gt4Binary-SmaCC_TSV_Parser'
}

{ #category : #generated }
TPSVParseNodeVisitor >> visitFile: aFile [
	^ self visitParse: aFile
]

{ #category : #generated }
TPSVParseNodeVisitor >> visitLine: aLine [
	^ self visitParse: aLine
]

{ #category : #generated }
TPSVParseNodeVisitor >> visitParse: aParse [
	^ self visitSmaCCParseNode: aParse
]
