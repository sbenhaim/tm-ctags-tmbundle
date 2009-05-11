TM Ctags
========

### Ctags code completion and navigation for TextMate.

Update Project Tags
-------------------

### ⌥⌘P

Builds or updates the tag index in the root directory of your project. This is a prerequisite to running any of the other commands in this bundle and should be run as your project changes.

This command will only work with a project or directory open in TextMate.

Jump to Current Tag
-------------------

### ⌃]

Jumps to the file and line where the tag under the cursor is defined.

Complete Tag
------------

### ⌘< (⌘⇧,)

Provides completions for the current word&mdash;including method/function arguments&mdash;pulling from the functions, methods, and classes defined in your project.

Jump to Tag...
--------------

### ⌘⇧P

Prompts for a tag (or the start of a tag) and jumps to the file and line where that tag is defined.

Shell Variables (advanced)
--------------------------

**TM\_CTAGS\_EXT\_LIB**

You can now exploit tags in another project by pointing the TM\_CTAGS\_EXT\_LIB project variable at another project root with a .tmtags file. Thanks to [seanfarley](http://github.com/seanfarley "seanfarley") for this contribution.

**TM\_CTAGS\_EXCLUDES**

Space-delimited list of files or directories you don't want tagged. Shell wildcards work. (.git, .svn, and .cvs are already excluded.) For example:

<pre>.hg *.js</pre>

**TM\_CTAGS\_INCLUDES**

Space-delimited list of files you <u>do</u> want tagged. TM\_CTAGS\_EXCLUDES is ignored if you use TM\_CTAGS\_INCLUDES. 

**Update:** These now use the same format as TM\_CTAGS\_EXCLUDES, not extended regexp format. Shell wildcards work.

**TM\_CTAGS\_OPTIONS**

Have your own ctags configuration? Save it to a file and point this shell variable at it. (Maps to --options.) Excludes and includes are ignored if you specify your own options.

(There are a few options required for proper functionality of this bundle which will be added to the argument list you provide.)

**TM\_CTAGS\_RESULT\_LIMIT**

Only 300 matching results are displayed by default. Use this setting to override this value.