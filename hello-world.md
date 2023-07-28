# Hello world!
This is my first website, built with my very own static website generator!
I'm really excited to be able to use what I've built.

Well, I guess I'll use the rest of this page to tell you a bit
more about the exciting parts of my project.
 (also maybe a bit about how satisfied I am with it)

You can find the code on my GitHub [right here](https://github.com/haxala1r/site-generator).

# What it does
From a user standpoint, this project accomplishes three main things:

- Gives you a convenient, easy-to-use and concise interface and [Domain-Specific Language](https://en.wikipedia.org/wiki/Domain-specific_language) to generate HTML and CSS code from Common Lisp code
- Lets you swiftly and painlessly generate HTML code from the Markdown format.
- Combining the two above points, lets you generate an entire website from just a template written in the DSL mentioned in point 1 and HTML code compiled from a Markdown file (as mentioned in point 2). The command-line tool even lets you convert multiple markdown files into websites using the same template!


# How it does what it does

To get a little more involved with the code, here is how a simple page
with a blue "Hello world!" text would look in my HTML DSL:

`(html (body (p :attrs (:color "blue") "Hello world!")))`

...which generates:

`<html><body><p color="blue"> Hello world! </p></body></html>`

Well, at first this may not look any different than regular HTML, but this has
a few advantages that regular HTML doesn't:

- It has no closing tags. Just closing parentheses, like normal Common Lisp code.
- Perhaps more importantly, you can execute regular code *inside* the HTML-generating code. So `(p (* 5 5))` is equivalent to `(p 25)`. This also means that File and Network I/O can be done, if necessary.
- Conversely, regular Common Lisp code can also make use of this language. So for example, you can make use of my project to type `(print (p (i "hello world!")))` at the repl, and that would print "<p><i>hello world!</i></p>".

The last two points are especially important, because that's the part that lets us
generate static web pages from a template and markdown file, and does so elegantly.

Essentially, the template is first evaluated as Common Lisp code.
The template, while being evaluated (or executed, in this context), executes code
that reads and processes the markdown file. However the code that tokenizes, parses
and then evaluates the markdown file itself makes use of even more Common Lisp code that
generates HTML code, which is how we're able to turn (or *compile*) `*text*` into `<i>text</i>`.

It's quite amazing, isn't it?

## Compiling Markdown


The next big component of my project is the Markdown compiler, which tokenizes, then parses
the input markdown into an appropriate AST.

If you'd like some more details, here's how the transformation goes.
Sorry if I'm detailing too much here, but I kind of want to show what I learnt here,
so here we go...
 

- `*hello world*` is taken as input.
- The tokenizer converts this into a list of tokens, each of which is in fact an ast-node object. For this input, the list of tokens would be:
 - First, an ast-node containing "*" as its value (because `*` is a token), and `'STAR` as its type.
 - Second, an ast-node containing "hello world" as its value (there are no special tokens here, so it's treated as text) with `'TEXT` as its type.
 - Third, another star. Same as the first one.
 - Lastly, an EOF token is inserted at the end of the token stream. This is always done to ensure the parser knows when the stream is going to end.
- This list of tokens is then compared to all known "parsers", which are actually functions that take a list of tokens and return a new ast-node and the remaining tokens. In this case, `paragraph-parser` is the high-level parser that matches this.
- *That* function internally attempts to match with the parsers for codeblocks, links, bolds, italics etc. etc. until it reaches the one that matches.
- The italics parser for example, attempts to match, in order:
 - a node that has the type `'STAR`
 - here, it attempts to match (again) codeblocks, links, bolds, regular text etc. etc. until a match is found or fails.
 - The above point means that we can accurately parse nested formattings. *So **we** `can` [**have**](https://rickroll.com)* **`many`** complicated things happen in text, and still be able to parse it properly. This "recursive descent" structure (essentially, the fact that a parser can (and should!) call other parsers (even *itself*)) is what made it click for me. It's what makes parsing complicated structures like this possible, and I'm glad I started this journey... anyway.
 - then, matches another star. If successful so far, return a new `'ITALIC` node with whatever was in between the stars as its value.
- You see the point. This parsing logic keeps continuing until every last token has been matched by something and an AST has been assembled.
- After this, the compiler walks through the tree and generates HTML code, using the tools made available in the above section.

The end result is that you can use this code: `(process-markdown-string "*hello **world***")`

... and it generates this string: `"<p><i>hello <b>world</b></i></p>"`

Or, if you think that was too simple of an example, take this page you're viewing right now. Yes, this page (along with the rest of the site) was generated with this very tool, you can view the source (both the markdown and the template) on my GitHub account.
