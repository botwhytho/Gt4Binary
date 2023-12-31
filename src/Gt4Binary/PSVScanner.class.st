Class {
	#name : #PSVScanner,
	#superclass : #SmaCCScanner,
	#category : #'Gt4Binary-SmaCC_TSV_Parser'
}

{ #category : #generated }
PSVScanner >> emptySymbolTokenId [
	^ 10
]

{ #category : #generated }
PSVScanner >> errorTokenId [
	^ 11
]

{ #category : #generated }
PSVScanner >> scan1 [
	[ self step.
	currentCharacter == $"
		ifTrue: [ self recordMatch: #(2).
			self step.
			currentCharacter == $" ifTrue: [ ^ self scan1 ].
			^ self reportLastMatch ].
	true ] whileTrue
]

{ #category : #generated }
PSVScanner >> scan2 [
	[ self step.
	currentCharacter == $'
		ifTrue: [ self recordMatch: #(2).
			self step.
			currentCharacter == $' ifTrue: [ ^ self scan2 ].
			^ self reportLastMatch ].
	true ] whileTrue
]

{ #category : #generated }
PSVScanner >> scanForToken [
	self step.
	currentCharacter == Character lf ifTrue: [ ^ self recordAndReportMatch: #(3) ].
	currentCharacter == Character cr
		ifTrue: [ self recordMatch: #(3).
			self step.
			currentCharacter == Character lf
				ifTrue: [ ^ self recordAndReportMatch: #(3) ].
			^ self reportLastMatch ].
	currentCharacter == $" ifTrue: [ ^ self scan1 ].
	currentCharacter == $' ifTrue: [ ^ self scan2 ].
	currentCharacter == $| ifTrue: [ ^ self recordAndReportMatch: #(1) ].
	true
		ifTrue: [ [ self recordMatch: #(2).
			self step.
			currentCharacter <= Character tab
				or: [ (currentCharacter between: Character pageUp and: Character newPage)
						or: [ (currentCharacter between: (Character value: 14) and: ${)
								or: [ currentCharacter >= $} ] ] ] ] whileTrue ].
	^ self reportLastMatch
]
