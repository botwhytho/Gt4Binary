Class {
	#name : #PSVParseNode,
	#superclass : #SmaCCParseNode,
	#category : #'Gt4Binary-SmaCC_TSV_Parser'
}

{ #category : #generated }
PSVParseNode >> acceptVisitor: aParseVisitor [
	^ aParseVisitor visitParse: self
]
