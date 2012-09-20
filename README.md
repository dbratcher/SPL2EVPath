SPL2EVPath
==========

Author: Drew Bratcher
Email: dbratcher at gatech dot edu

Project to  build a translator that converts code from ibm's stream processing language to georgia tech's evpath framework

Files
-------------

spl.l - flex lexer 
spl.y - grammar and semantic action
parse.c - runs lexer and parser
main.c - generated code



Current SPL Support
------------------

Functor
Barrier
Aggregate


Examples
-----------------
trivial.spl
simpleSplit.spl
simpleBarrier.spl
simpleAggregate.spl
