Extension { #name : #String }

{ #category : #'*Gt4Binary' }
String >> withOSLineEndings [
	"Answer a new instance where all line endings are substituted wiht the character or set of characters defined in `OSPlatform current lineEnding`"

	^ self withLineEndings: OSPlatform current lineEnding
]
