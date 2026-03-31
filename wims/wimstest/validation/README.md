# WIMS W3C inline Validation
Validation in line of a module OEF or a document (for the moment), only the first page of the exercise

## Install
Need [w3c-validator.py](https://github.com/srackham/w3c-validator/blob/master/w3c-validator.py) in the directory validation

## Use
Launch the script from the directory validation

To use on one module write:

    ./checkhtmlwims $option $module_address

with $option = 0 or 1

and $module_address the address of the module
 from the directory `wims/public_html/modules`

This module address can be either one module (`E1/number/oefnumber.fr`),
or a category of modules (`E1/number`), or a comma-separated list of zones (`U1,E5,Lang,devel`),
or empty : in this case all "level"-zones (E1..U4) and Lang are treated.

**The results are in the directory "result".**

## Samples

Check (first page of) all exercices from the module `U1/analysis/oefderint.fr` without cleaning :

    ./checkhtmlwims 0 U1/analysis/oefderint.fr

Check all exercises of all modules in U1/analysis and then clean to erase uninteresting errors :

    ./checkhtmlwims 1 U1/analysis

Check all modules of the zones E5,devel and Lang and clean results :

    ./checkhtmlwims 1  E5,devel,Lang

Check all "level"-zones (E1..U4) and Lang, without cleaning :

    ./checkhtmlwims 0


For glossary (the result is in the file "tmp/html.log")

    ./checkhtmlglossary 1
