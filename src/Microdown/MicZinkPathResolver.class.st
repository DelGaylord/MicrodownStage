"
I am a path resolver for microdown.
References in microdown (currently (2021-11-19) links, images and inputfiles) can be either absolute references to a specific file or http address, or relative to an absolute reference.

I am a visitor which is given a base/absolute reference, and traverses a document and **resolves** all relative references with respect to the base reference. Resolution is to replace the relative reference with an absolute.

The mention of `Zink` in my name is a credit to the zink library ZnUrl which does the underlying resolution.
"
Class {
	#name : #MicZinkPathResolver,
	#superclass : #MicrodownVisitor,
	#instVars : [
		'baseUri'
	],
	#category : #'Microdown-Core'
}

{ #category : #'instance creation' }
MicZinkPathResolver class >> resolve: document withBase: aZnUrl [
	"Assumes aZnUrl to be an absolute uri. Converts all relative references to absolute references in document"
	self new
		baseUri: aZnUrl;
		visit: document
		
]

{ #category : #accessing }
MicZinkPathResolver >> baseUri: aZnUrl [
	baseUri := aZnUrl
]

{ #category : #visiting }
MicZinkPathResolver >> visitFigure: aFigure [
	| resolvedUri |
	aFigure reference isResolved 
		ifTrue: [ ^self ].
	resolvedUri := baseUri withRelativeReference: aFigure reference relativePath.
	aFigure reference: (MicResourceReference fromUri: (resolvedUri printString))
	
]

{ #category : #visiting }
MicZinkPathResolver >> visitInputFile: anInputFile [
]

{ #category : #visiting }
MicZinkPathResolver >> visitLink: aLink [
]