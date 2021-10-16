Class {
	#name : #MicRealDumperTest,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'factory',
		'visitor',
		'parser'
	],
	#category : #'Microdown-PrettyPrinter-Tests'
}

{ #category : #tests }
MicRealDumperTest class >> testParameters [ 
	^ super testParameters
			addCase: { #visitor -> MicDumper };
		yourself.
]

{ #category : #accessing }
MicRealDumperTest >> factory [ 
	^ factory
]

{ #category : #accessing }
MicRealDumperTest >> factory: aFactory [
	factory := aFactory
]

{ #category : #'tests - section' }
MicRealDumperTest >> parse: aString andCheckWeGet: anExpectedString [

	| mic result |
	mic := parser parse: aString.
	result := (visitor visit: mic children first).
	self assert: result contents equals: anExpectedString
]

{ #category : #'tests - section' }
MicRealDumperTest >> recreateFrom: aString sameObjectAs: resString [
	
	| origObject resObject |
	origObject := parser parse: aString.
	resObject := OpalCompiler new source: resString; evaluate.
	self assert: origObject equals: resObject
]

{ #category : #running }
MicRealDumperTest >> setUp [
	super setUp.
	factory := MicMicrodownSnippetFactory new.
	visitor := MicRealDumper new.
	parser := MicroDownParser new
]

{ #category : #'tests - section' }
MicRealDumperTest >> testMonospaceFormat [

	| mic result |
	mic := parser parse: factory monospaceFormatSample.
	result := (visitor visit: mic children first).
	self assert: result contents equals: '(MicMonospaceFormatBlock new text: )'
	
]

{ #category : #'tests - section' }
MicRealDumperTest >> testPrintHeader [
	
	| resString |
	resString := '(MicHeaderBlock new level: 3; header: ''Foo'')'.
	self parse: factory headerLevel3Sample andCheckWeGet: resString.
	
	
	


]

{ #category : #'tests - section' }
MicRealDumperTest >> testPrintOrderedList [

   | resString |
	resString := ('MicOrderedListBlock').
	self parse: factory orderedListSample andCheckWeGet: resString.
	
]

{ #category : #'tests - section' }
MicRealDumperTest >> testPrintParagraph [

	| resString |
	resString := '(MicParagraphBlock new )'.
	self parse: factory paragraphSample andCheckWeGet: resString.
	

]

{ #category : #'tests - section' }
MicRealDumperTest >> testPrintUnorderedList [

	| resString |
	resString := 'MicUnorderedListBlock'.
	self parse: factory unorderedListSample andCheckWeGet: resString.
	
]

{ #category : #accessing }
MicRealDumperTest >> visitor [

	^ visitor
]

{ #category : #accessing }
MicRealDumperTest >> visitor: anObject [

	visitor := anObject
]