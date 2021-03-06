#  NumberedLines

This small project implements an editable text view with source-editor like numbers.

![Image from the App](NumberedLinesScreen.jpg)

## Here's the actual coding assignment from Apple:

>I’d like to have you complete the following coding exercise: [NumberedLinesCodingExercise.md](NumberedLinesCodingExercise.md)

>Here is the text file that should be included in the app’s bundle and loaded into the text view: [TextViewContent.txt](NumberedLines/TextViewContent.txt)

>And here is a video showing an example of the user interactions we’re looking for: [NumberedLinesVideo.mov](https://mail.deathstar.org/~myke/images/NumberedLinesVideo.mov)

>I like this challenge because there are many ways to achieve this. Pick the one that looks the best while staying performant.

## Design Notes

This is my first time using documention comments (which have been a thing since at least Xcode 6).  I like!  I'll have to figure out how to incorporate these into my own personal work.

I'm not certain how many other candidates you've sent this project to, but I quickly found somebody else's implementation over at https://github.com/yichizhang/NSTextView-LineNumberView 

That project's use of a subclassed NSRulerView is freakin' cool (and in fact I use custom drawing in a NSRulerView in a teleprompter project I worked on), but I purposely decided to implement mine dramatically differently to show another approach.  

My approach is to use a table view to hold the line numbers (and if these line numbers were selectable/editable, I suspect we could easily implement some nifty bells & whistles for the project... like swapping lines of text)

I did not do anything explicit for cut/copy/paste, undo/redo or spell-checking (which are enabled by default).  For scrolling, I ported the "synchronized scrolling" sample code from Objective-C to Swift, so the table view of line numbers keeps synchronized with the text view (and vice versa, if I had the scroll bar enabled on the table view).  

For a new document, I do use the "TextViewContent.txt" file that was included with the assignment, but I do open previous documents with their updated content.  I did spend a bit of time implementing reading & writing, just because I wanted to undersand NSDocument-based reading & writing a bit better (and I opened up a public pull request back to Yichizhang's open source project to implement reading & writing for his project as well).  I hope this won't be a ding against me.

## Why this fails

A couple days after I submitted this project, I got the message back that they weren't satisfied with this project and that they weren't going to move forward with me.  Here's the relevant quote:

>We had some concerns about the coding exercise. The look and feel of the table view with the text view wasn’t quite right, and the line number behavior broke down when the line content wrapped. 

I'd dispute their summarization since I recalculate the line numbers whenever the contents of the text view change or when the frame changes, but I also wasn't super happy with how the two scroll views weren't perfectly synchronizing.  I am proud though, of how much I got accomplished in about two hours of work.  

If you have additional suggestions or fixes, feel free to open a pull request or type in some bugs.

Thanks for looking!

