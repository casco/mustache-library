Class {
	#name : #ExampleMustacheLibrary,
	#superclass : #MustacheLibrary,
	#category : #'Mustache-Library-Core'
}

{ #category : #templates }
ExampleMustacheLibrary >> pharoBookExample [
^'Hello {{ name }} 
You have just won ${{value}}!{{#in_ca}}
Well, ${{taxed_value}}, after taxes {{/in_ca}}'
]

{ #category : #templates }
ExampleMustacheLibrary >> pharoBookExample_exampleContext [
^'{"name" :  "Chris",
"value" : 10000,
"taxed_value" : 699,
"in_ca" :  true }'
]
