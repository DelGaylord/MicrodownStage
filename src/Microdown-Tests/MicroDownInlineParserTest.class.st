Class {
	#name : #MicroDownInlineParserTest,
	#superclass : #TestCase,
	#instVars : [
		'parser'
	],
	#category : #'Microdown-Tests'
}

{ #category : #parsing }
MicroDownInlineParserTest >> parse: aString [
 	"self new parse: 'foo_abbb_zz' "
 	| contents doc elements |
 	doc := (MicroDownParser parse: aString).
 	contents := doc  children first text.
 	elements := MicInlineSplitter new start: contents.
 	doc children: { (MicParagraphBlock new children: elements)}. 
 	^ doc
]

{ #category : #parsing }
MicroDownInlineParserTest >> parseAndReturnElementsOfParagraphFor: aString [ 
 	"self new parse: 'foo_abbb_zz' "
 	^ (self parse: aString) children first children
 
]

{ #category : #tests }
MicroDownInlineParserTest >> testAnchor [
 	| elements |
 	elements := (self parseAndReturnElementsOfParagraphFor: 'abc*@anchors@*def').
 	self assert: elements size equals: 3.
 	self assert: elements first substring equals: 'abc'.
 	self assert: elements second substring equals: 'anchors'.
 	self assert: elements second kind equals: 'anchorReference'.
 	self assert: elements second openingDelimiter equals: '*@'.
 	self assert: elements second closingDelimiter equals: '@*'
]

{ #category : #tests }
MicroDownInlineParserTest >> testAnchorWithoutClosure [
 	| elements |
 	elements := (self parseAndReturnElementsOfParagraphFor: 'abc*@anchorsdef').
 	self assert: elements size equals: 1.
 	self assert: elements first substring equals: 'abc*@anchorsdef'
]

{ #category : #tests }
MicroDownInlineParserTest >> testAnnotations [
 	| elements |
 	elements := (self parseAndReturnElementsOfParagraphFor: 'abc<?footnote | value=A foonote is anannotation.?>def').
 	self assert: elements size equals: 3.
 	self assert: elements first substring equals: 'abc'.
 	self assert: elements second substring equals: 'footnote | value=A foonote is anannotation.'.
 	self assert: elements second kind equals: 'annotation'.
 	self assert: elements second openingDelimiter equals: '<?'.
 	self assert: elements second closingDelimiter equals: '?>'
 
]

{ #category : #tests }
MicroDownInlineParserTest >> testAnnotationsWithoutClosure [
 	| elements |
 	elements := (self parseAndReturnElementsOfParagraphFor: 'abc<?footnote | value=A foonote is anannotation.def').
 	self assert: elements size equals: 1.
 	self assert: elements first substring equals: 'abc<?footnote | value=A foonote is anannotation.def'
 
]

{ #category : #tests }
MicroDownInlineParserTest >> testBolds [ 
 	| elements |
 	elements := (self parseAndReturnElementsOfParagraphFor: 'abc**bolds**def').
 	self assert: elements size equals: 3.
 	self assert: elements first substring equals: 'abc'.
 	self assert: elements second substring equals: 'bolds'.
 	self assert: elements second kind equals: 'bold'.
 	self assert: elements second openingDelimiter equals: '**'
 
]

{ #category : #tests }
MicroDownInlineParserTest >> testBoldsAndNestedItalics [ 
 	| elements |
	self skip.
	"MicBoldInline substring return _bolds_ but we wait to obtain bolds"
 	elements := (self parseAndReturnElementsOfParagraphFor: 'abc**_bolds_**def').
 	self assert: elements size equals: 3.
 	self assert: elements first substring equals: 'abc'.
 	self assert: elements second substring equals: 'bolds'.
 	self assert: elements second kind equals: 'bold'.
 	self assert: elements second openingDelimiter equals: '**'
 
]

{ #category : #tests }
MicroDownInlineParserTest >> testBoldsAndNestedItalicsWithClosureAfterOpenItalics [
 	| elements |
 	elements := (self parseAndReturnElementsOfParagraphFor: 'abc**_bolds**_def').
 	self assert: elements size equals: 3.
 	self assert: elements first substring equals: 'abc'.
 	self assert: elements second substring equals: '_bolds'.
	self assert: elements third substring equals: '_def'.
 	self assert: elements second kind equals: 'bold'.
 	self assert: elements second openingDelimiter equals: '**'
 
]

{ #category : #tests }
MicroDownInlineParserTest >> testBoldsWithoutClosure [ 
 	| elements |
 	elements := (self parseAndReturnElementsOfParagraphFor: 'abc**boldsdef').
 	self assert: elements size equals: 1.
 	self assert: elements first substring equals: 'abc**boldsdef'
 
]

{ #category : #tests }
MicroDownInlineParserTest >> testEscape [
 	| elements |
 	elements := (self parseAndReturnElementsOfParagraphFor: 'abc\_bolds_def').
 	self assert: elements size equals: 1.
 	self assert: elements first substring equals: 'abc_bolds_def'.
 	self assert: elements first kind equals: 'basic'.
 
]

{ #category : #tests }
MicroDownInlineParserTest >> testFigure [
 	| elements |
 	elements := (self parseAndReturnElementsOfParagraphFor: 'abc![caption](url?parameters=value)def').
 	self assert: elements size equals: 3.
 	self assert: elements first substring equals: 'abc'.
 	self assert: elements second substring equals: 'caption'.
 	self assert: elements second kind equals: 'figure'.
 	self assert: elements second openingDelimiter equals: '!['.
 	self assert: elements second closingDelimiter equals: ')'
]

{ #category : #tests }
MicroDownInlineParserTest >> testItalics [
 	| elements |
 	elements := (self parseAndReturnElementsOfParagraphFor: 'abc_italics_def').
 	self assert: elements size equals: 3.
 	self assert: elements first substring equals: 'abc'.
 	self assert: elements second substring equals: 'italics'.
 	self assert: elements second kind equals: 'italic'.
 	self assert: elements second openingDelimiter equals: '_'
]

{ #category : #tests }
MicroDownInlineParserTest >> testItalicsAndNestedBolds [
 	| elements |
	self skip.
	"MicItalicInline substring return **italics** but we wait to obtain italics"
 	elements := (self parseAndReturnElementsOfParagraphFor: 'abc_**italics**_def').
 	self assert: elements size equals: 3.
 	self assert: elements first substring equals: 'abc'.
 	self assert: elements second substring equals: 'italics'.
 	self assert: elements second kind equals: 'italic'.
 	self assert: elements second openingDelimiter equals: '_'
]

{ #category : #tests }
MicroDownInlineParserTest >> testItalicsAndNestedBoldsWithClosureAfterOpenBolds [
 	| elements |
 	elements := (self parseAndReturnElementsOfParagraphFor: 'abc_**italics_**def').
 	self assert: elements size equals: 3.
 	self assert: elements first substring equals: 'abc'.
 	self assert: elements second substring equals: '**italics'.
	self assert: elements third substring equals: '**def'.
 	self assert: elements second kind equals: 'italic'.
 	self assert: elements second openingDelimiter equals: '_'
 
]

{ #category : #tests }
MicroDownInlineParserTest >> testItalicsWithoutClosure [
 	| elements |
 	elements := (self parseAndReturnElementsOfParagraphFor: 'abc_italicsdef').
 	self assert: elements size equals: 1.
 	self assert: elements first substring equals: 'abc_italicsdef'
]

{ #category : #tests }
MicroDownInlineParserTest >> testLink [
 	| elements |
 	elements := (self parseAndReturnElementsOfParagraphFor: 'abc[caption](url?parameters=value)def').
 	self assert: elements size equals: 3.
 	self assert: elements first substring equals: 'abc'.
 	self assert: elements second substring equals: 'caption'.
 	self assert: elements second kind equals: 'linkName'.
 	self assert: elements second openingDelimiter equals: '['.
 	self assert: elements second closingDelimiter equals: ')'
]

{ #category : #tests }
MicroDownInlineParserTest >> testMath [
 	| elements |
 	elements := (self parseAndReturnElementsOfParagraphFor: 'abc$V_i = C_0 - C_3$def').
 	self assert: elements size equals: 3.
 	self assert: elements first substring equals: 'abc'.
 	self assert: elements second substring equals: 'V_i = C_0 - C_3'.
 	self assert: elements second kind equals: 'math'.
 	self assert: elements second openingDelimiter equals: '$'
]

{ #category : #tests }
MicroDownInlineParserTest >> testMonospaces [
 	| elements |
 	elements := (self parseAndReturnElementsOfParagraphFor: 'abc`monospaces`def').
 	self assert: elements size equals: 3.
 	self assert: elements first substring equals: 'abc'.
 	self assert: elements second substring equals: 'monospaces'.
 	self assert: elements second kind equals: 'monospace'.
 	self assert: elements second openingDelimiter equals: '`'

]

{ #category : #tests }
MicroDownInlineParserTest >> testMonospacesWithoutClosure [
 	| elements |
 	elements := (self parseAndReturnElementsOfParagraphFor: 'abc`monospacesdef').
 	self assert: elements size equals: 1.
 	self assert: elements first substring equals: 'abc`monospacesdef'

]

{ #category : #tests }
MicroDownInlineParserTest >> testRaws [
 	| elements |
 	elements := (self parseAndReturnElementsOfParagraphFor: 'abc{{raws}}def').
 	self assert: elements size equals: 3.
 	self assert: elements first substring equals: 'abc'.
 	self assert: elements second substring equals: 'raws'.
 	self assert: elements second kind equals: 'raw'.
 	self assert: elements second openingDelimiter equals: '{{'.
 	self assert: elements second closingDelimiter equals: '}}'
]

{ #category : #tests }
MicroDownInlineParserTest >> testRawsWithBolds [
 	| elements |
 	elements := (self parseAndReturnElementsOfParagraphFor: 'abc{{**raws**}}def').
 	self assert: elements size equals: 3.
 	self assert: elements first substring equals: 'abc'.
 	self assert: elements second substring equals: '**raws**'.
 	self assert: elements second kind equals: 'raw'.
 	self assert: elements second openingDelimiter equals: '{{'.
 	self assert: elements second closingDelimiter equals: '}}'
]

{ #category : #tests }
MicroDownInlineParserTest >> testRawsWithItalics [
 	| elements |
 	elements := (self parseAndReturnElementsOfParagraphFor: 'abc{{_raws_}}def').
 	self assert: elements size equals: 3.
 	self assert: elements first substring equals: 'abc'.
 	self assert: elements second substring equals: '_raws_'.
 	self assert: elements second kind equals: 'raw'.
 	self assert: elements second openingDelimiter equals: '{{'.
 	self assert: elements second closingDelimiter equals: '}}'
]

{ #category : #tests }
MicroDownInlineParserTest >> testRawsWithMonospaces [
 	| elements |
 	elements := (self parseAndReturnElementsOfParagraphFor: 'abc{{`raws`}}def').
 	self assert: elements size equals: 3.
 	self assert: elements first substring equals: 'abc'.
 	self assert: elements second substring equals: '`raws`'.
 	self assert: elements second kind equals: 'raw'.
 	self assert: elements second openingDelimiter equals: '{{'.
 	self assert: elements second closingDelimiter equals: '}}'
]

{ #category : #tests }
MicroDownInlineParserTest >> testRawsWithStrikes [
 	| elements |
 	elements := (self parseAndReturnElementsOfParagraphFor: 'abc{{~raws~}}def').
 	self assert: elements size equals: 3.
 	self assert: elements first substring equals: 'abc'.
 	self assert: elements second substring equals: '~raws~'.
 	self assert: elements second kind equals: 'raw'.
 	self assert: elements second openingDelimiter equals: '{{'.
 	self assert: elements second closingDelimiter equals: '}}'
]

{ #category : #tests }
MicroDownInlineParserTest >> testRawsWitoutClosure [
 	| elements |
 	elements := (self parseAndReturnElementsOfParagraphFor: 'abc{{rawsdef').
 	self assert: elements size equals: 1.
 	self assert: elements first substring equals: 'abc{{rawsdef'
]

{ #category : #tests }
MicroDownInlineParserTest >> testStrikes [
 	| elements |
 	elements := (self parseAndReturnElementsOfParagraphFor: 'abc~strikes~def').
 	self assert: elements size equals: 3.
 	self assert: elements first substring equals: 'abc'.
 	self assert: elements second substring equals: 'strikes'.
 	self assert: elements second kind equals: 'strike'.
 	self assert: elements second openingDelimiter equals: '~'
]

{ #category : #tests }
MicroDownInlineParserTest >> testStrikesWithoutClosure [
 	| elements |
 	elements := self parseAndReturnElementsOfParagraphFor: 'abc~strikesdef'.
 	self assert: elements size equals: 1.
 	self assert: elements first substring equals: 'abc~strikesdef'

]