Class {
	#name : #ToMiniBrowser,
	#superclass : #Object,
	#instVars : [
		'listsPane',
		'mainPane',
		'packages',
		'classes',
		'protocols',
		'selectors',
		'codeModel',
		'codePane',
		'classSide'
	],
	#category : #'Toplo-Examples'
}

{ #category : #'instance creation' }
ToMiniBrowser class >> open [
	<script>
	self new open
]

{ #category : #'class selection' }
ToMiniBrowser >> candidateProtocolsForClass: aClass [

	| prots |
	prots := classSide
		         ifTrue: [ aClass organization allProtocols select: [ :p | aClass isLocalMethodsProtocol: p ] ]
		         ifFalse: [ aClass organization allProtocols ].
	^ prots sort: [ :a :b | a name < b name ]
]

{ #category : #'code editor' }
ToMiniBrowser >> changeCodeInEditor [

	| selected cls sel codeText |

	selected := selectors list at: selectors selectedIndexes anyOne.
	cls := selected key.
	sel := selected value.
	codeModel styler classOrMetaClass: cls.
	codeText := cls sourceCodeAt: sel.
	codeModel text: codeText copy
]

{ #category : #'class selection' }
ToMiniBrowser >> classSelectionChangedEvent: aToSelectionChanged [

	| selectedClasses allProtocols |
	protocols selectionStrategy clearSelection.
	protocols list removeAll.
	selectedClasses := aToSelectionChanged newSelectedIndexes collect: [ :idx | classes list at: idx ].
	allProtocols := Array streamContents: [ :stream | 
		                selectedClasses do: [ :cls | 
			                | side prots |
			                side := classSide
				                        ifTrue: [ cls classSide ]
				                        ifFalse: [ cls instanceSide ].
			                prots := self candidateProtocolsForClass: side.
			                prots := self
				                         finalProtocolsFrom: prots
				                         forClass: side.
			                stream nextPutAll: prots ] ].

	selectedClasses size > 1 ifTrue: [ allProtocols := self filteredProtocolsFrom: allProtocols ].
	protocols list addAll: allProtocols
]

{ #category : #accessing }
ToMiniBrowser >> classSide [

	^ classSide ifNil: [ classSide := false ]

]

{ #category : #'code editor' }
ToMiniBrowser >> clearCodeInEditor [

	codeModel styler classOrMetaClass: nil.
	codeModel text: ''

]

{ #category : #'class selection' }
ToMiniBrowser >> filteredProtocolsFrom: aListOfProtocols [

	^ aListOfProtocols collect: [ :assoc | 
		  | p |
		  p := assoc value.
		  p name = AllProtocol defaultName
			  ifTrue: [ 
				  | fake |
				  fake := Protocol new name: p name , ' ' , assoc key name.
				  fake addAllMethodsFrom: p.
				  assoc key -> fake ]
			  ifFalse: [ assoc ] ]
]

{ #category : #'class selection' }
ToMiniBrowser >> finalProtocolsFrom: aListOfProtocols forClass: aClass [

	^ Array streamContents: [ :stream | 
		  aListOfProtocols do: [ :prot | 
			  prot name = AllProtocol defaultName
				  ifTrue: [ 
					  | fake |
					  fake := Protocol new name: (String streamContents: [ :str | str nextPutAll: AllProtocol defaultName ]).
					  fake addAllMethodsFrom: prot.
					  stream nextPut: aClass -> fake ]
				  ifFalse: [ 
					  prot name = Protocol nullCategory ifFalse: [ 
						  stream nextPut: aClass -> prot ] ] ] ]
]

{ #category : #initialization }
ToMiniBrowser >> initialize [

	| codeMenu classesPane classesButtonPane sideToggle |
	super initialize.
	listsPane := ToHorizontalPane new margin: (BlInsets top: 5 bottom: 5).
	listsPane layout: (BlLinearLayout horizontal cellSpacing: 5).
	listsPane matchParent.
	
	mainPane := ToVerticalPane new.
	mainPane matchParent.

	packages := ToList new nodeFactory: [ :pkg | 
		            ToLabeledNode new
			            labelText: pkg name;
			            hMatchParent ].
	"packages hasFixedSize: true."
	"packages selectionStrategy beWithoutSelection."
	packages
		when: ToSelectionChangedEvent
		do: [ :event | self packageSelectionChangedEvent: event ].
	packages list addAll:
		(RPackage organizer packages asSortedCollection: [ :p1 :p2 | 
			 p1 name < p2 name ]).

	classes := ToList new nodeFactory: [ :cls | 
		           ToLabeledNode new
			           labelText: cls name;
			           hMatchParent ].
	classes
		when: ToSelectionChangedEvent
		do: [ :event | self classSelectionChangedEvent: event ].
	classes list whenRemoveChangeDo: [ protocols list removeAll ].
	classesPane := ToVerticalPane new matchParent.
	classesPane addChild: classes.
	classesButtonPane := ToHorizontalPane new
		                     hMatchParent;
		                     vFitContent.
	classesButtonPane addChild: (sideToggle := ToToggleButton new
			               label: (ToLabel text: 'Class side');
			               beLabelFirst;
								
			               margin: (BlInsets top: 5);
			               padding: (BlInsets all: 0)).
	sideToggle layout cellSpacing: 5.
	classesPane addChild: classesButtonPane.

	sideToggle check: self classSide.
	sideToggle whenCheckedDo: [ 
		classes dispatchSelectionChangedAfter: [ classSide := true ] ].
	sideToggle whenUncheckedDo: [ 
		classes dispatchSelectionChangedAfter: [ classSide := false ] ].

	protocols := ToList new nodeFactory: [ :assoc | 
		             ToLabeledNode new
			             labelText: assoc value name;
			             hMatchParent ].

	protocols
		when: ToSelectionChangedEvent
		do: [ :event | self protocolSelectionChangedEvent: event ].
	protocols list whenRemoveChangeDo: [ selectors list removeAll ].

	selectors := ToList new nodeFactory: [ :assoc | 
		             ToLabeledNode new
			             labelText: assoc value asString;
			             hMatchParent ].
	selectors
		when: ToSelectionChangedEvent
		do: [ :event | self selectorSelectionChangedEvent: event ].
	selectors list whenRemoveChangeDo: [ self clearCodeInEditor ].
	"selectors hasFixedSize: true."
	
	codeModel := ToAlbumModel new withRowNumbers.
	codeModel styler: BlRBTextStyler new.
	codePane := codeModel onWidget margin: (BlInsets all: 5).

	codeMenu := ToContextMenu new globalColumnWidth: 0.
	codeMenu addItem: (ToButtonMenuItem new labelText: 'Accept').
	codePane contextMenu: codeMenu.

	packages withRowNumbers.
	classes withRowNumbers.
	protocols withRowNumbers.
	selectors withRowNumbers.

	listsPane addChild: packages.
	listsPane addChild: classesPane.
	listsPane addChild: protocols.
	listsPane addChild: selectors.

	mainPane addChild: listsPane.
	mainPane addChild: codePane
]

{ #category : #opening }
ToMiniBrowser >> open [

	mainPane openInOBlSpace title: 'Mini browser'
]

{ #category : #initialization }
ToMiniBrowser >> packageSelectionChangedEvent: aToSelectionChanged [

	| selectedPackages clsList |
	classes selectionStrategy clearSelection.
	classes list removeAll.
	selectedPackages := aToSelectionChanged newSelectedIndexes collect: [ :idx | packages list at: idx ].
	clsList := Array streamContents: [:stream | selectedPackages do: [ :pkg | stream nextPutAll: pkg definedClasses ] ].
	clsList := clsList asSortedCollection: [ :a :b | a name < b name ].
	classes list addAll: clsList
]

{ #category : #initialization }
ToMiniBrowser >> protocolSelectionChangedEvent: aToSelectionChanged [

	| selectedProtocols |
	selectors selectionStrategy clearSelection.
	selectors list removeAll.
	selectedProtocols := aToSelectionChanged newSelectedIndexes collect: [ :idx | protocols list at: idx ].
	selectedProtocols do: [ :assoc | selectors list addAll: ((assoc value methodSelectors asSortedCollection) collect: [:sel | assoc key -> sel] ) ]
		

]

{ #category : #initialization }
ToMiniBrowser >> selectorSelectionChangedEvent: aToSelectionChanged [

	aToSelectionChanged newSelectedIndexes size = 1 ifTrue: [ ^ self changeCodeInEditor ].
	self clearCodeInEditor
]