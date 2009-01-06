TM Ctags
========

### Ctags meets TextMate.

Update Tags
-----------

### ⌥⌘P

Builds a .tmtags file in the root directory of your project. This is a prerequisite to running any of the other commands in this bundle and should be run as your project changes.

This (and all other commands in this bundle) will only work with a project or directory open in TextMate.

Jump to Current Tag
-------------------

### ⌃]

Jumps to the file and line where the tag under the cursor is declared.

Project Completion
------------------

### ⌘< (⇧⌘,)

Provides completions for the current word&mdash;including method/function arguments&mdash;pulling from the functions, methods, and classes declared in your project.

Jump to Tag...
--------------

### ⌘⇧P

Prompts for a tag (or the start of a tag) and jumps to the file and line where that tag is declared.

TM\_CTAGS\_EXTRA\_LIB
---------------------

You can now exploit tags in another project by pointing a TM\_CTAGS\_EXTRA\_LIB project variable at another project root with a .tmtags file. Thanks [seanfarley](http://github.com/seanfarley "seanfarley").