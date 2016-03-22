# relative-jump.el

Relative, alphanumertic line jumping.

A simple package to allow the user to jump relative lines using an
alphanumeric relative line numbering.

### Why?

I never really got into `ace-jump`, a fault of my own. I found that I
tended to think more in terms of lines than target characters.  When
using `ace-jump` I found myself pausing to wait for the target
character to be labeled before moving on.

`relative-jump` is a little different because the lines are always
there and you can type the line offset while examining the target
region or thinking about what you're going to do when you get there.

### Usage

Put `relative-jump.el` in your `load-path`. My config looks something
like this:

```
(require 'relative-jump)

;; Bind Control-Alt-n to a forward jump
(global-set-key (kbd "C-M-n") 'relative-jump-forward)

;; Bind Control-Alt-n to a backward jump
(global-set-key (kbd "C-M-p") 'relative-jump-backward)

;; Set the linum format
(setq linum-relative-format "%3s› ")
```

### Example

With the above setup, the keystrokes `C-M-n c RET` will jump forward
to line `c` containing `((symbolp x) (symbol-value x)))`.

```
d ›
c ›
b › (cond ((numberp x) x)
a ›       ((stringp x) x)
  ›       ((bufferp x)
a ›        (setq temporary-hack x) ; multiple body-forms
b ›        (buffer-name x))        ; in one clause
c ›       ((symbolp x) (symbol-value x)))
d ›
```

For longer buffers, the letters are appended with a number multiplier.

```
d › (cond ((numberp x) x)
c ›       ((stringp x) x)
b ›       ((bufferp x)
a ›        (setq temporary-hack x) ; multiple body-forms
  ›        (buffer-name x))        ; in one clause
a ›       ((symbolp x) (symbol-value x)))
...
a2›
b2›
c2›
..
a3›
b3›
```

You simply enter `a3`, `c2`, etc. to jump to line specified!

The jump distance is calculated by `26*(N - 1) + A` where `N` is the
numeric multiplier and `A` is the distance of the alphabetic character
from the beginning of the alphabet plus one.

* The keystrokes `C-M-n b1 RET` will jump forward `26*(1-1) + 2 = 2` lines.
* The keystrokes `C-M-n a2 RET` will jump forward `26*(2-1) + 1 = 27` lines.
* The keystrokes `C-M-n b2 RET` will jump forward `26*(2-1) + 2 = 28` lines.
* The keystrokes `C-M-n c4 RET` will jump forward `26*(4-1) + 3 = 81` lines.

### TODO

* Create cask

### License
Copyright (c) 2016 Joshua Miller

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
