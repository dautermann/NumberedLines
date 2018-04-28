#  NumberedLines

This small project implements an editable text view with source-editor like numbers.

## Design Notes

This is my first time using documention comments (which have been a thing since at least Xcode 6).  I like!  I'll have to figure out how to incorporate these into my own personal work.

I'm not certain how many other candidates you've sent this project to, but I quickly found somebody else's implementation over at https://github.com/yichizhang/NSTextView-LineNumberView 

That project's use of a subclassed NSRulerView is freakin' cool (and in fact I use custom drawing in a NSRulerView in a teleprompter project I worked on), but I purposely decided to implement mine dramatically differently to show another approach.  

My approach is to use a table view to hold the line numbers (and if these line numbers were selectable/editable, I suspect we could easily implement some nifty bells & whistles for the project... like swapping lines of text)

I did not do anything explicit for cut/copy/paste, undo/redo or spell-checking (which are enabled by default).  For scrolling, I ported the "synchronized scrolling" sample code from Objective-C to Swift, so the table view of line numbers keeps synchronized with the text view (and vice versa, if I had the scroll bar enabled on the table view).  

For a new document, I do use the "TextViewContent.txt" file that was included with the assignment, but I do open previous documents with their updated content.  I did spend a bit of time implementing reading & writing, just because I wanted to undersand NSDocument-based reading & writing a bit better (and I opened up a public pull request back to Yichizhang's open source project to implement reading & writing for his project as well).  I hope this won't be a ding against me.


