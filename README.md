This is a simple utility to help you deal with your Mustache templates. They are stores as methods in a library class and edited with the MustacheTemplateEditor

# Installation
You can load this librady using Metacello

```Smalltalk
Metacello new
  repository: 'github://casco/mustache-library:main';
  baseline: 'MustacheLibrary';
  load.
```

You can use the following dependency from your own Metacello configuration or baseline

```Smalltalk
spec baseline: 'MustacheLibrary' with: [ spec repository: 'github://casco/mustache-library:main' ].
```

# Open the editor
```
MustacheTemplateEditor new open
```
