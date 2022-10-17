Class {
	#name : #ToSandBox,
	#superclass : #Object,
	#category : #'Toplo-examples'
}

{ #category : #label }
ToSandBox class >> example_toLabel1 [

	| lab |
	lab := ToLabel new text: 'This is a Text'.
	lab openInOBlSpace 
]

{ #category : #label }
ToSandBox class >> example_toLabel2 [

	| lab |
	lab := ToLabel new text: (('This is a Text') asRopedText fontName: AeFontManager defaultCodeFontFamilyName; fontSize: 20).
	lab openInOBlSpace 
]

{ #category : #label }
ToSandBox class >> example_toLabel3 [

	| lab |
	lab := ToLabel new text: ('This is a bold text' asRopedText fontSize: 20).
	lab alignCenterRight.
	lab textElement bold.
	lab hFitContent.
	lab background: Color lightBlue.
	lab textElement foreground: Color gray.
	lab border: (BlBorder paint: Color yellow width: 1).
	lab openInOBlSpace
]

{ #category : #label }
ToSandBox class >> example_toLabel4 [

	| lab1 lab2 lab3 root |
	root := BlElement new constraintsDo: [ :c | 
		        c vertical matchParent.
		        c horizontal matchParent ].

	root layout: BlLinearLayout vertical.
	lab1 := ToLabel new text: ('First text' asRopedText fontSize: 14).
	lab1  border: (BlBorder paint: Color red width: 1).
	"lab1 addEditor."
	root addChild: lab1.
	lab2 := ToLabel new text: ('Second text' asRopedText fontSize: 14).
	lab2 border: (BlBorder paint: Color red width: 1).
	lab2 addEditor.
	root addChild: lab2.
	lab3 := ToLabel new text: ('Third text' asRopedText fontSize: 14).
	lab3 border: (BlBorder paint: Color red width: 1).
	"lab3 addEditor."
	root addChild: lab3.
	root openInOBlSpace.

]