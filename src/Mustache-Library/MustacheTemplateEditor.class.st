Class {
	#name : #MustacheTemplateEditor,
	#superclass : #SpPresenter,
	#instVars : [
		'newMethodButton',
		'classSelector',
		'methodsList',
		'notebook',
		'templatePresenter',
		'exampleContextPresenter',
		'exampleResultPresenter'
	],
	#category : #'Mustache-Library-Tools'
}

{ #category : #callbacks }
MustacheTemplateEditor >> acceptContextChanges [

	| source |
	source := String streamContents: [ :strm |
		          strm
			          nextPutAll: self selectedMethod selector;
						 nextPutAll: self exampleContextSuffix; 
			          cr;
			          nextPutAll: '^''';
			          nextPutAll: ((exampleContextPresenter text escapeCharacter: $'));
			          nextPutAll: '''' ].
	self selectedLibraryClass
		compile: source
		classified: self templatesProtocol.
	self updateNotebook .
	
		
 
]

{ #category : #callbacks }
MustacheTemplateEditor >> acceptTemplateChanges [

	| source |
	source := String streamContents: [ :strm |
		          strm
			          nextPutAll: self selectedMethod selector;
			          cr;
			          nextPutAll: '^''';
			          nextPutAll: ((templatePresenter text escapeCharacter: $'));
			          nextPutAll: '''' ].
	self selectedLibraryClass
		compile: source
		classified: self templatesProtocol.
	self updateNotebook .
	
		
 
]

{ #category : #callbacks }
MustacheTemplateEditor >> addNewTemplate [

	| templateSource exampleContextSource selector |
	selector := self
		            request:
		            'Provide a name (valid selector) for the template'
		            initialAnswer: ''
		            title: 'Template name'.
	selector := selector asValidSelector.
	selector ifEmpty: [ ^ self ].
	templateSource := selector , '
	^ ''Hi {{ name }}, this is a simple template'''.
	exampleContextSource := selector , self exampleContextSuffix , '
^''{"name" : "Juan"}''
'.

	self selectedLibraryClass
		compile: templateSource
		classified: self templatesProtocol.
	self selectedLibraryClass
		compile: exampleContextSource
		classified: self templatesProtocol.

	self updateMethodsList
]

{ #category : #private }
MustacheTemplateEditor >> asCleanedUpSource: aString [

	^ (aString escapeCharacter: $') escapeCharacter: $"
]

{ #category : #callbacks }
MustacheTemplateEditor >> cancelContextChanges [
	self updateNotebook 
]

{ #category : #callbacks }
MustacheTemplateEditor >> cancelTemplateChanges [
	self updateNotebook 
]

{ #category : #initialization }
MustacheTemplateEditor >> connectPresenters [

	classSelector whenSelectedItemChangedDo: [ :selectedLibraryClass |
		self updateMethodsList ].
	methodsList whenSelectedItemChangedDo: [ :selectedMethod |
		self updateNotebook ]
]

{ #category : #initialization }
MustacheTemplateEditor >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		  add: (SpBoxLayout newTopToBottom
				   add: classSelector expand: false;
				   add: methodsList;
					add: newMethodButton expand: false;
				   yourself)
		  expand: false;
		  add: notebook;
		  yourself
]

{ #category : #accessing }
MustacheTemplateEditor >> exampleContext [

	| exampleContextMethod |
	^ self selectedLibraryClass ifNil: [ ^ '' ] ifNotNil: [ :it |
		  exampleContextMethod := it lookupSelector:
			                          self selectedMethod selector
			                          , self exampleContextSuffix.
		  exampleContextMethod
			  ifNil: [ '' ]
			  ifNotNil: [ :method |
			  self selectedLibraryClass new perform: method selector ] ]
]

{ #category : #constants }
MustacheTemplateEditor >> exampleContextSuffix [

	^ '_exampleContext'
]

{ #category : #accessing }
MustacheTemplateEditor >> exampleResult [

	^ (MustacheTemplate on: self template) value: (NeoJSONReader fromString: self exampleContext)
]

{ #category : #initialization }
MustacheTemplateEditor >> initialExtent [

	^ (900 @ 600) scaledByDisplayScaleFactor
]

{ #category : #initialization }
MustacheTemplateEditor >> initializeContextPresenter [

	exampleContextPresenter := self newText.
	exampleContextPresenter contextMenu: [(SpMenuPresenter new
			 addItem: [ :item |
				 item
					 name: 'Accept';
					 action: [ self acceptContextChanges ] ];
			 addItem: [ :item |
				 item
					 name: 'Cancel';
					 action: [ self cancelContextChanges ] ];
			 yourself)]
]

{ #category : #initialization }
MustacheTemplateEditor >> initializePresenters [

	super initializePresenters.
	classSelector := self newDropList.
	classSelector items: self libraryClasses.
	classSelector selectItem: nil.
	classSelector display: [ :item |
		item ifNil: [ '' ] ifNotNil: [ item name ] ].
	methodsList := self newList.
	methodsList display: [ :item | item selector ].
	newMethodButton := self newButton
		                   label: 'New template';
		                   action: [ self addNewTemplate ];
		                   yourself.
	self initializeTemplatePresenter.
	self initializeContextPresenter.
	exampleResultPresenter := self newText
		                          beNotEditable;
		                          yourself.
	notebook := self newNotebook
		            addPageTitle: 'Template'
		            provider: [ templatePresenter ];
		            addPageTitle: 'Example context'
		            provider: [ exampleContextPresenter ];
		            addPageTitle: 'Example result'
		            provider: [ exampleResultPresenter ]
]

{ #category : #initialization }
MustacheTemplateEditor >> initializeTemplatePresenter [

	templatePresenter := self newText.
	templatePresenter contextMenu: [(SpMenuPresenter new
			 addItem: [ :item |
				 item
					 name: 'Accept';
					 action: [ self acceptTemplateChanges ] ];
			 addItem: [ :item |
				 item
					 name: 'Cancel';
					 action: [ self cancelTemplateChanges ] ];
			 yourself)]
]

{ #category : #initialization }
MustacheTemplateEditor >> initializeWindow: aWindow [

	super initializeWindow: aWindow.
	aWindow title: 'Mustache library templates editor'

]

{ #category : #accessing }
MustacheTemplateEditor >> libraryClasses [

	^ MustacheLibrary allSubclasses
		  addFirst: nil;
		  yourself
]

{ #category : #accessing }
MustacheTemplateEditor >> selectedLibraryClass [

	^ classSelector selectedItem
]

{ #category : #accessing }
MustacheTemplateEditor >> selectedMethod [

	^ methodsList selectedItem
]

{ #category : #accessing }
MustacheTemplateEditor >> template [

	^ self selectedLibraryClass new perform: self selectedMethod selector
]

{ #category : #accessing }
MustacheTemplateEditor >> templateMethodsInSelectedLibraryClass [

	^ self selectedLibraryClass ifNil: [ #(  ) ] ifNotNil: [ :it |
		  (it methodsInProtocol: self templatesProtocol) reject: [ :each |
			  each selector includes: $_ ] ]
]

{ #category : #constants }
MustacheTemplateEditor >> templatesProtocol [

	^ 'templates'
]

{ #category : #callbacks }
MustacheTemplateEditor >> updateMethodsList [

	methodsList items: self templateMethodsInSelectedLibraryClass
]

{ #category : #callbacks }
MustacheTemplateEditor >> updateNotebook [

	| selectedMethod |
	selectedMethod := methodsList selectedItem.

	selectedMethod
		ifNil: [
			templatePresenter text: ''.
			exampleContextPresenter text: ''.
			exampleResultPresenter text: '' ]
		ifNotNil: [
			templatePresenter text: (self template).
			exampleContextPresenter text: self exampleContext.
			exampleResultPresenter text: self exampleResult ]
]
