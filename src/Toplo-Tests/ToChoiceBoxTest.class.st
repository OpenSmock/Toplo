"
A ToChoiceBoxTest is a test class for testing the behavior of ToChoiceBox
"
Class {
	#name : #ToChoiceBoxTest,
	#superclass : #TestCase,
	#category : #'Toplo-Tests-Widget-ChoiceBox'
}

{ #category : #' tests' }
ToChoiceBoxTest >> assertEmpty: aChoiceBox [

	self assert: aChoiceBox group buttons isEmpty.	
	self assert: aChoiceBox placeHolder isNil.
	self assert: aChoiceBox menuButton label isNil.
	self assert: aChoiceBox menuButton icon notNil.
	self assert: aChoiceBox data isEmpty.
	self assert: aChoiceBox selectedData isNil.
	self assert: aChoiceBox dataToTextConverter notNil.

]

{ #category : #' tests' }
ToChoiceBoxTest >> testAddRemoveOneStringData [

	| cb d |
	cb := ToChoiceBox new.
	d := '#1'.
	cb data add: d.
	cb data remove: d.
	self assertEmpty: cb

]

{ #category : #' tests' }
ToChoiceBoxTest >> testCheckUncheckWithUncheckStrategy [

	| cb d1 d2 d3 |
	cb := ToChoiceBox new.
	cb withUncheckingStrategy.
	d1 := '#1'.
	d2 := '#2'.
	d3 := '#3'.
	cb data addAll: {
			d1.
			d2.
			d3 }.
	cb selectedIndex: 1.
	self assert: cb data size equals: 3.
	self assert: cb selectedData equals: d1.
	self assert: cb menuButton label text asString equals: d1.
	self assert: cb group buttons size equals: 3.
	cb group buttons first uncheck.
	self assert: cb group buttons first isUnchecked.
	self assert: cb group buttons second isUnchecked.
	self assert: cb group buttons third isUnchecked
]

{ #category : #' tests' }
ToChoiceBoxTest >> testEmpty [

	| cb d |
	cb := ToChoiceBox new.
	self assertEmpty: cb.
	d := 'Some text' asRopedText.
	self assert: (cb dataToTextConverter value: d) equals: d.
]

{ #category : #' tests' }
ToChoiceBoxTest >> testNoSelectedData [

	| cb d |
	cb := ToChoiceBox new.
	d := { '#1'. '#2'. '#3'. '#4'. '#5' }.
	cb data addAll: d.
	self assert: cb selectedData isNil.
	self assert: cb menuButton label isNil.
	self assert: (cb group buttons noneSatisfy: [ :b | b isChecked ])
]

{ #category : #' tests' }
ToChoiceBoxTest >> testNoSelectedDataWithPlaceHolder [

	| cb |
	cb := ToChoiceBox new.
	cb placeHolder: (ToLabel text: 'No choice').
	self assert: cb selectedData isNil.
	self assert: cb menuButton label text asString equals: 'No choice'.
	self assert: (cb group buttons noneSatisfy: [ :b | b isChecked ]).
	cb selectedData: nil.
	self assert: cb selectedData isNil.
	self assert: cb menuButton label text asString equals: 'No choice'.
	self assert: (cb group buttons noneSatisfy: [ :b | b isChecked ])
]

{ #category : #' tests' }
ToChoiceBoxTest >> testNoSelectedDataWithPlaceHolder2 [

	| cb d |
	cb := ToChoiceBox new.
	cb placeHolder: (ToLabel text: 'No choice').
	d := { '#1'. '#2'. '#3'. '#4'. '#5' }.
	cb data addAll: d.
	cb selectedIndex: 1.
	self assert: cb selectedData equals: '#1'.
	self assert: cb menuButton label text asString equals: d first.
	cb selectedData: nil.
	self assert: cb selectedData isNil.
	self assert: cb menuButton label text asString equals: 'No choice'.
	self assert: (cb group buttons noneSatisfy: [ :b | b isChecked ])
]

{ #category : #' tests' }
ToChoiceBoxTest >> testPlaceHolder [

	| cb |
	cb := ToChoiceBox new.
	cb data addAll: { 'A'. 'B'. }.
	cb placeHolder: (ToLabel text: 'X').
	self assert: cb menuButton label text asString equals: 'X'.
	cb group buttons first check.
	self assert: cb selectedData equals: 'A'.
	self assert: cb menuButton label text asString equals: 'A'.
	" strict strategy do not allow unchecking "
	cb group buttons first uncheck.
	self assert: cb menuButton label text asString equals: 'A'.
	self assert: cb selectedData equals: 'A'
]

{ #category : #' tests' }
ToChoiceBoxTest >> testPlaceHolder2 [

	| cb |
	cb := ToChoiceBox new.
	cb withUncheckingStrategy.
	cb data addAll: { 'A'. 'B'. }.
	cb placeHolder: (ToLabel text: 'X').
	self assert: cb menuButton label text asString equals: 'X'.
	cb group buttons first check.
	self assert: cb selectedData equals: 'A'.
	self assert: cb menuButton label text asString equals: 'A'.
	" Unchecking strategy does allow unchecking "
	cb group buttons first uncheck.
	self assert: cb menuButton label text asString equals: 'X'.
	self assert: cb selectedData isNil.

	

]

{ #category : #' tests' }
ToChoiceBoxTest >> testPlaceHolder3 [

	| cb |
	cb := ToChoiceBox new.
	cb withUncheckingStrategy.
	cb data addAll: { 'A'. 'B'. }.
	cb placeHolder: (ToLabel text: 'X').
	self assert: cb menuButton label text asString equals: 'X'.
	cb selectedData: 'A'.
	self assert: cb group buttons first isChecked.
	self assert: cb selectedData identicalTo: cb data first.
	self assert: cb menuButton label text asString equals: 'A'.
	" Unchecking strategy does allow unchecking "
	cb selectedData: nil.
	self assert: cb group buttons first isUnchecked.
	self assert: cb menuButton label identicalTo: cb placeHolder.
	self assert: cb selectedData isNil.

	

]

{ #category : #' tests' }
ToChoiceBoxTest >> testSelectedData1 [

	| cb d |
	cb := ToChoiceBox new.
	d := { '#1'. '#2'. '#3'. '#4'. '#5' }.
	cb data addAll: d.
	cb selectedIndex: 1.
	self assert: cb selectedData equals: d first.
	cb selectedData: d second.
	self assert: cb menuButton label text asString equals: d second.
	self assert: cb group buttons second isChecked
]

{ #category : #' tests' }
ToChoiceBoxTest >> testSelectedData2 [

	| cb d |
	cb := ToChoiceBox new.
	d := { '#1'. '#2'. '#3'. '#4'. '#5' }.
	cb data addAll: d.
	cb selectedIndex: 1.
	self assert: cb selectedData equals: '#1'.
	cb selectedData: '#99999'.
	self assert: cb selectedData equals: '#1'.
	self assert: cb menuButton label text asString equals: d first.
	self assert: cb group buttons first isChecked
]

{ #category : #' tests' }
ToChoiceBoxTest >> testWith5StringData [

	| cb d |
	cb := ToChoiceBox new.
	d := { '#1'. '#2'. '#3'. '#4'. '#5' }.
	cb data addAll: d.
	cb selectedIndex: 1.
	self assert: cb data size equals: 5.
	self assert: cb selectedData equals: d first.
	self assert: cb menuButton label text asString equals: d first.
	self assert: cb menuButton subMenuWindow root children size equals: 5.
	self assert: cb group buttons size equals: 5.
	self assert: cb placeHolder isNil.
	cb data removeAll.
	self assertEmpty: cb
]

{ #category : #' tests' }
ToChoiceBoxTest >> testWithOneStringData [

	| cb d |
	cb := ToChoiceBox new.
	d := '#1'.
	cb data add: d.
	cb selectedIndex: 1.
	self assert: cb data size equals: 1.
	self assert: cb selectedData equals: d.
	self assert: cb menuButton label text asString equals: d.
	self assert: cb menuButton subMenuWindow root children size equals: 1.
	self assert: cb group buttons size equals: 1.
	self assert: cb placeHolder isNil
]

{ #category : #' tests' }
ToChoiceBoxTest >> testWithStrictStrategy [

	| cb d1 d2 d3 |
	cb := ToChoiceBox new.
	d1 := '#1'.
	d2 := '#2'.
	d3 := '#3'.
	cb data addAll: {
			d1.
			d2.
			d3 }.
	cb selectedIndex: 1.
	self assert: cb data size equals: 3.
	self assert: cb selectedData equals: d1.
	self assert: cb menuButton label text asString equals: d1.
	self assert: cb menuButton subMenuWindow root children size equals: 3.
	self assert: cb group buttons size equals: 3.
	self assert: cb group buttons first isChecked.
	self assert: cb group buttons second isUnchecked.
	self assert: cb group buttons third isUnchecked.
	self assert: cb placeHolder isNil.
	cb group buttons first uncheck.
	self assert: cb group buttons first isChecked
]

{ #category : #' tests' }
ToChoiceBoxTest >> testWithUncheckStrategy [

	| cb d1 d2 d3 |
	cb := ToChoiceBox new.
	cb withUncheckingStrategy.
	d1 := '#1'.
	d2 := '#2'.
	d3 := '#3'.
	cb data addAll: {
			d1.
			d2.
			d3 }.
	self assert: cb data size equals: 3.
	cb selectedData: d1.
	self assert: cb menuButton label text asString equals: d1.
	self assert: cb menuButton subMenuWindow root children size equals: 3.
	self assert: cb group buttons size equals: 3.
	self assert: cb group buttons first isChecked.
	self assert: cb group buttons second isUnchecked.
	self assert: cb group buttons third isUnchecked.
	self assert: cb placeHolder isNil.
	cb group buttons first uncheck.
	self assert: cb menuButton label isNil
]