---
title: "TCL Tutorial "
author: "Juan David Guerrero Balaguera, Ph.D"
date: "January 25, 2026"
output: beamer_presentation
---

# Introduction

- TCl (Tool Command Lnaguage) is a high-level, general-purpose, interpreted, dynamic programming language. 
- TCL is widely used in EDA tools, enabling the creation of automations, interconecting different tools in a common way. 

<div style="text-align: center;">
    <img src="./doc/TCL-logo.png" width="20%" >
</div>

# Hello World

In order to execute TCL commands it is necesary to have a tool or a shell with such support. In this tutorial we will use **`tclsh`** which is available in any linux system. When working with EDA tools, TCL can be executed directly on the tool shell.

### Executing `tclsh`

- Run the **`tclsh`** 
 ```bash
 /fos/designs > tclsh
 %
 ```

- As any other language, let's write a "Hello World". This command will display and string on the TCL shell.

### Hello World {.example}
```tcl
puts "Hello, World!"
```

---

### Two commands, single line {.example}

```tcl
puts "Hello," ; puts "World!"
```

- You can execute two consecutive commands in the same line, as usually is done in bash

### Comments in TCL {.example}

```tcl
# This is a comment
```

- Comments should be written at the first line, or separated by semicolons.

### Comments rules {.example}

```tcl
# this is a comment
puts "Hello, World!" # This is a comment
puts "Hello, World!" ; # This is a comment
```
- You gota be careful, avoid adding comments at the end of any TCL command w/o semicolon

## Handling variables 

### Assign values to variables {.example}

```tcl
set a 5 ; # Assign 5 to variable a
```

### Dereference a variable {.example}

```tcl
puts $a ; # prints 5
puts a ; # prints 5
puts "$a" ; # prints 5, string
```
### Print especial characters like "$" {.example}

```tcl
puts "\$a" ; #prints $a
```

---

### Dereferencing a variable within an string {.example}

```tcl
puts "$a4" ; # Error
```
### Curly brackets {} used to derefence a varible {.example}
```tcl
puts ${a}4 ; # prints 54
```

## Evalauting expressions 

### TCL Expressions {.example}

```tcl
2+2 ; # Error
"2+2" ; # Just and string
expr 2+2 ; # Returns 4
```


### Expressions and variables

```tcl
set b 2+2 ; # string
puts $b 
set b expr 2+2 ; # error
set b [expr 2+2] ; # sets b with 4
puts $b
```


# Lists

### List definitions
```tcl
set l1 "1 2 3" ; # spaces make a list, string
set l2 {4 5 6} ; # Nother list definition, values
set l3 [list 7 8 9]
puts "List 1 is $l1, List 2 is $l2, and List 3 is $l3"
```

### List lenght
```tcl 
llength $l1
```

### List indexing
```tcl 
lindex $l1 0
lindex $l2 1
lindex $l3 end
lindex $l3 end-1
```

---

### List sorting
```tcl
set l4 "b c a"
lsort $l4
```

# Loops

### While loop

```tcl
set i 0
while {$i<10} {
    puts $i
    incr i
}
```

### foreach loop
```tcl
set l1 "1 2 3"
foreach list_item $l1 {
    puts $list_item
}
```

# Conditionals and Procs

### if-else conditional
```tcl
set a 5
if {$a==5} {puts "yes"}

if {$a==5} {puts "5"} elseif {$a==4} {puts "4"} else {puts "none"}

set a 3
if {$a==5} {puts "5"} elseif {$a==4} {puts "4"} else {puts "none"}
```

### procs

```tcl
proc plus {a b} {
    return [expr $a + $b]
}

plus 4 5
plus 5
plus 123 343
```

# Asociative Arrays

- They are equivalent to a dictionaries in `Python` or structures in `C`

### Array declaration

```tcl
set courses(EDI) 81010
set courses(EDII) 81011
set courses(uC) 83010
set courses(uP) 83011
set courses(DAD) 99999
puts $courses ; # this is wrong
puts $courses(EDI)
```

### Array builtin functions
```tcl
array size courses
array names courses
array get courses
```

---

### Iterating an array (Opt1)

```tcl
foreach coursename [array names courses] {
    puts "$coursename $courses($coursename)"
}
```

### Iterating an array (Opt2)
```tcl
foreach {coursename courseid} [array get courses] {
    puts "$coursename $courseid"
}
```

### Environmental variables

```tcl
puts $env(PWD)
```

### Command execution
```tcl
exec ls
```

# Printing with format

### format command
```tcl
format "%f" 43.5
format "%e" 43.5
format "%d\t%s" 5 ${courses(DAD)}
```


# Files

### Create a file

```tcl
set fh [open "my_file.txt" w]
puts $fh "This string now goes to the file"
close $fh
```

### Append content to a file
```tcl
set fh [open "my_file.txt" a]
puts $fh "line1"
puts $fh "line2"
close $fh
```

### Read file content
```tcl
set fh [open "my_file.txt" r]
gets $fh oneline
puts "$oneline"
close $fh
```

---

### Read file content
```tcl
set fh [open "my_file.txt" r]
while {[gets $fh oneline]>0}{
    puts "$oneline"
}
close $fh
```

### Read file content
```tcl
set fh [open "my_file.txt" r]
set data [read $fh]
puts $data
close $fh
```

# Summary

### {.alert}
This is tutorial provided you the basic undertanding of TCL, more complex and advanced TCL usage can be found freely on the web, feel free to explore more.