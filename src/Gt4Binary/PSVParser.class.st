Class {
	#name : #PSVParser,
	#superclass : #SmaCCParser,
	#category : #'Gt4Binary-SmaCC_TSV_Parser'
}

{ #category : #'generated-accessing' }
PSVParser class >> cacheId [
	^'2023-10-11T01:28:03.29908-04:00'
]

{ #category : #private }
PSVParser class >> dataValueFrom: aSmaCCToken [
	| string |
	string := aSmaCCToken value.
	string isEmpty
		ifTrue: [ ^ nil ].
	string first = $'
		ifTrue:
			[ ^ (string copyFrom: 2 to: string size - 1)
				copyReplaceAll: ''''''
				with: '''' ].
	string first = $"
		ifTrue:
			[ ^ (string copyFrom: 2 to: string size - 1)
				copyReplaceAll: '""'
				with: '"' ].
	^ string trimBoth
]

{ #category : #generated }
PSVParser class >> definitionComment [
"%prefix PSV;
%suffix Node;

%root Parse;


<entry> 
	: [^\""\'\|\r\n] [^\|\r\n]*
	| (\"" [^\""]* \"") +
	| (\' [^\']* \') +
	;
<newline>
	: \r \n? | \n
	;

File
	: Lines {{}}
	;
Lines
	: Line 'line'
	| Lines <newline> 'eol' Line 'line'
	;
Line
	: Value 'value' {{}}
	| Line ""|"" 'pipe' Value 'value' {{}}
	;
Value
	: <entry>
	| Missing
	;
Missing
	: {SmaCCToken value: '' start: self position ids: #()}
	;"
]

{ #category : #'file types' }
PSVParser class >> fileExtension [
	^ '.csv'
]

{ #category : #'file types' }
PSVParser class >> fileExtensionType [
	^ 'CSV files'
]

{ #category : #parsing }
PSVParser class >> parseStringOrFileWithHeader: aFilename [
	| lines headerLine headerNames |
	lines := self parseStringOrFileWithoutHeader: aFilename.
	lines isEmpty
		ifTrue: [ ^ lines ].
	headerLine := lines removeFirst.
	headerNames := (1 to: headerLine size)
		collect: [ :i | (headerLine at: i) ifNil: [ 'Column ' , i printString ] ].
	1 to: lines size do:
		[ :i | 
		| dict |
		dict := Dictionary new: headerNames size.
		headerNames
			with: (lines at: i)
			do: [ :header :value | dict at: header put: value ].
		lines at: i put: dict ].
	^ lines
]

{ #category : #parsing }
PSVParser class >> parseStringOrFileWithoutHeader: aFilename [
	| file maxSize lines |
	file := aFilename isString
			ifTrue: [ self parse: aFilename ]
			ifFalse: [ self parseFile: aFilename ].
	maxSize := file lines
			inject: 0
			into: [ :sum :each | sum max: each values size ].
	lines := file lines
			collect: [ :each | 
				| line |
				line := Array new: maxSize.
				1
					to: each values size
					do: [ :i | line at: i put: (self dataValueFrom: (each values at: i)) ].
				line ].
	(file lines size > 0
		and: [ file lines last pipes isEmpty
				and: [ (self dataValueFrom: file lines last values first) isNil ] ])
		ifTrue: [ lines removeLast ].
	^ lines
]

{ #category : #generated }
PSVParser class >> reduceTable [
^#(
	#(9 0 #reduceActionForMissing1: 343041 false) 
	#(8 1 #liftFirstValue: 311297 false) 
	#(5 1 #reduceActionForFile1: 156673 false) 
	#(6 1 #reduceActionForLines1: 179201 false) 
	#(7 1 #reduceActionForLine1: 241665 false) 
	#(8 1 #liftFirstValue: 311298 false) 
	#(6 3 #reduceActionForLines2: 179202 false) 
	#(7 3 #reduceActionForLine2: 241666 false)
	).
]

{ #category : #'generated-accessing' }
PSVParser class >> scannerClass [
	^PSVScanner
]

{ #category : #generated }
PSVParser class >> startingStateForFile [
	^ 1
]

{ #category : #generated }
PSVParser class >> symbolNames [
	^ #('"|"' '<entry>' '<newline>' 'B e g i n' 'File' 'Lines' 'Line' 'Value' 'Missing' 'E O F' 'error')
]

{ #category : #generated }
PSVParser class >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #PSVFileNode #PSVFileNode #OrderedCollection #PSVLineNode #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCErrorNode)
]

{ #category : #generated }
PSVParser class >> transitionTable [
^#(
#[1 0 6 0 1 0 25 0 2 0 6 0 3 0 13 0 5 0 17 0 6 0 21 0 7 0 25 0 8 0 25 0 9 0 6 0 10] 
#[0 0 10 0 1 0 3 0 10] 
#[0 0 0 0 10] 
#[1 0 33 0 3 0 14 0 10] 
#[1 0 37 0 1 0 18 0 3 0 18 0 10] 
#[0 0 22 0 1 0 3 0 10] 
#[0 0 26 0 1 0 3 0 10] 
#[1 0 6 0 1 0 25 0 2 0 6 0 3 0 41 0 7 0 25 0 8 0 25 0 9 0 6 0 10] 
#[1 0 6 0 1 0 45 0 2 0 6 0 3 0 45 0 8 0 45 0 9 0 6 0 10] 
#[1 0 37 0 1 0 30 0 3 0 30 0 10] 
#[0 0 34 0 1 0 3 0 10]
	).
]

{ #category : #'generated-reduction actions' }
PSVParser >> reduceActionForFile1: nodes [
	| result |
	result := PSVFileNode new.
	result addNodes: ((nodes at: 1) at: 1) to: result lines.
	result addTokens: ((nodes at: 1) at: 2) to: result eols.
	^ result
]

{ #category : #'generated-reduction actions' }
PSVParser >> reduceActionForLine1: nodes [
	| result |
	result := PSVLineNode new.
	result addToken: (nodes at: 1) to: result values.
	^ result
]

{ #category : #'generated-reduction actions' }
PSVParser >> reduceActionForLine2: nodes [
	| result |
	result := nodes at: 1.
	result addToken: (nodes at: 2) to: result pipes.
	result addToken: (nodes at: 3) to: result values.
	^ result
]

{ #category : #'generated-reduction actions' }
PSVParser >> reduceActionForLines1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (OrderedCollection new: 2).
	result at: 2 put: (OrderedCollection new: 2).
	self add: (nodes at: 1) to: (result at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
PSVParser >> reduceActionForLines2: nodes [
	| result |
	result := nodes at: 1.
	self add: (nodes at: 2) to: (result at: 2).
	self add: (nodes at: 3) to: (result at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
PSVParser >> reduceActionForMissing1: nodes [
	^ SmaCCToken value: '' start: self position ids: #()
]
