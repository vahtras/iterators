<script type="text/javascript"
  src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
# Introduction to iterators

## Olav Vahtras

KTH

---

layout: false

## Iterators and generators

### Iterators

* objects that support iteration protocol
* i.e. to be used in for loops

#### Some well-known iterators

* A list

```
>>> li = range(3)
>>> for i in li:
...     print i,
0 1 2

```
**Note**

* In python2 *range* return a list of a given size
* In python2 *xrange* generates a sequence one by one
* In python3 *range* has the same meaning as xrange 

---

#### Dictionaries support iteration

* The loop variable is the key of the key-value pair

```
>>> dict = {'a':1, 'b':2}
>>> for k in dict:
...     print k, dict[k]
a 1
b 2

```
--

#### Strings support iteration

```
>>> str = 'abc'
>>> for c in str:
...     print c
a
b
c

```
---

#### File objects  support iteration


```
>>> import subprocess
>>> subprocess.call("/bin/echo 'one\ntwo\nthree' > 123", shell=True)
0
>>> for row in open('123'):
...     print row,
one
two
three

```
---

### Consider the list

```
>>> print li
[0, 1, 2]

```

* Lists have an `__iter__` method


```
>>> li_iter = li.__iter__()
>>> print type(li_iter)
<type 'listiterator'>

```
* `__iter__` returns an object with a `next` method

```
>>> print li_iter.next()
0
>>> print li_iter.next()
1
>>> print li_iter.next()
2
>>> print li_iter.next()
Traceback (most recent call last):
  File "iter.py", line 20, in <module>
    print li_iter.next()
StopIteration

```

* Illustrates what happens behind the scenes in a for loop

---

### Objects supporting iteration

* have a method `__iter__()` which returns an iterable object
* the iterable has a method `next()` producing the next sequence value
* going beyond the last value raises a `StopIteration` - the for loop quits

---

### Defining your own iterator

```
>>> class Counter(object):
...     def __init__(self, size):
...         print "__init__:", size
...         self.size = size
...         self.start = 0
...
...     def __iter__(self):
...         print "__iter__:", self.size
...         return self
...
...     def next(self):
...         if self.start < self.size:
...             self.start = self.start + 1
...             return self.start
...         raise StopIteration

```
```
>>> c = Counter(3)
__init__: 3
>>> for num in c:
...     print num,
__iter__: 3
1 2 3

```

---

### Generators


* Functions that contain the  yield statment
* Support iteration protocol - they return an iterator
* Resumable
* Generators are not executed when invoked, they are iterated over

### function vs. generator

```
>>> def f(n):
...    return n
>>> print type(f), type(f(1))
<type 'function'> <type 'int'>

```
```
>>> def g(n):
...    yield n
>>> print type(g), type(g(1))
<type 'function'> <type 'generator'>

```

---

### Example

```
>>> def g(n):
...     print 'enter g with',n
...     yield n
...     print 'after yield'

```
```
>>> g2=g(2)
>>> g2.next()
enter g with 2
2
>>> g2.next() #doctest: +SKIP
after yield
Traceback (most recent call last):
...
StopIteration

```

* So: this function appears to pause at the yield statement after returning the value and continue from there the next time the next() method is called...

* When the function exits a StopIteration exception is raised

---

### Example

```
>>> def g(n):
...     print 'enter g with ',n
...     i=0
...     while i < n:
...         yield i
...         print 'after yield'
...         i += 1
...     print 'after while'

```
```
>>> g2=g(2)

```
--
```
>>> g2.next()
enter g with  2
0

```
--
```
>>> g2.next()
after yield
1

```
--

```
>>> g2.next() #doctest: +SKIP
after yield
after while
Traceback (most recent call last):
  File "gen.py", line 42, in <module>
    print g2.next()
StopIteration

```

### Iterator in for loop

```
>>> for  i in g(5):
...     print i,
enter g with  5
0 after yield
1 after yield
2 after yield
3 after yield
4 after yield
after while

```

### Example: fibonacci


```
>>> def fib(n):
...     a = 1
...     b = 2
...     while a < n:
...         yield a
...         a, b = b, a + b
>>> for i in fib(5):
...     print i,
1 2 3

```

### Convert to list

```
It is always possible to convert a generator to a list


```
>>> print list(fib(100))
[1, 2, 3, 5, 8, 13, 21, 34, 55, 89]
```

---

### Summary

* Several common types support iteration (list, dict, file, str)
* Objects support iteration have an `__iter__` function returning an iterable
* The iterables have a `next` method that steps through some sequence
* Generators are functions with a `yield` statement and work like iterators
