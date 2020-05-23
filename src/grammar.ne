@{%
import { Difference, Division, Modulo, UnaryFunction, Power, NAryFunction, CellRange, CellReference, sum, mul, mean, median } from './ast';
import moo from 'moo';

const lexer = moo.compile({
  whitespace: /[ \t]+/,
  number: /\d*[\.,]?\d+/,
  word: /[a-zA-Z]+/,
  operator:  /[\*\+-\/%(?:==)<>(?:<=)(?:>=)\^]/,
  parenthesis: /[\(\)]/,
  separator: /[;:]/,
});


%}

@lexer lexer
@preprocessor typescript

Expression   -> Sum

Sum          -> Sum _ "+" _ Product                         {% ([l,,,,r]) => new NAryFunction(sum, [l, r]) %}
              | Sum _ "-" _ Product                         {% ([l,,,,r]) => new Difference(l, r) %}
              | Product                                     {% id %}

Product      -> Product _ "*" _ Exponent                    {% ([l,,,,r]) => new NAryFunction(mul, [l, r]) %}
              | Product _ "/" _ Exponent                    {% ([l,,,,r]) => new Division(l, r) %}
              | Product _ "%" _ Exponent                    {% ([l,,,,r]) => new Modulo(l, r) %}
              | Exponent                                    {% id %}

Exponent     -> Prefix _ "^" _ Exponent                     {% ([l,,,,r]) => new Power(l, r) %}
              | Prefix                                      {% id %}

Prefix       -> "+" Parenthesis                             {% ([,x]) => x %}
              | "-" Parenthesis                             {% ([,x]) => new UnaryFunction(x => -x, x) %}
              | Parenthesis                                 {% id %}

Parenthesis  -> "(" _ Sum _ ")"                             {% ([,,x,,]) => x %}
              | Function                                    {% id %}

Function     -> UnaryFunc                                   {% id %}
              | NAryFunc                                    {% id %}
              | Literal                                     {% id %}

UnaryFunc    -> "sin"  _ Parenthesis                        {% ([,,x]) => new UnaryFunction(Math.sin, x) %}
              | "cos"  _ Parenthesis                        {% ([,,x]) => new UnaryFunction(Math.cos, x) %}
              | "tan"  _ Parenthesis                        {% ([,,x]) => new UnaryFunction(Math.tan, x) %}

              | "asin" _ Parenthesis                        {% ([,,x]) => new UnaryFunction(Math.asin, x) %}
              | "acos" _ Parenthesis                        {% ([,,x]) => new UnaryFunction(Math.acos, x) %}
              | "atan" _ Parenthesis                        {% ([,,x]) => new UnaryFunction(Math.atan, x) %}

              | "sqrt" _ Parenthesis                        {% ([,,x]) => new UnaryFunction(Math.sqrt, x) %}
              | "exp"  _ Parenthesis                        {% ([,,x]) => new UnaryFunction(Math.exp, x) %}
              | ("ln" | "log") _ Parenthesis                {% ([,,x]) => new UnaryFunction(Math.log, x) %}

NAryFunc     -> NAryFuncName _ "(" _ NAryFuncArgs _ ")"     {% ([f,,,args]) => new NAryFunction(f, args) %}

NAryFuncName -> "max"                                       {% () => Math.max %}
              | "min"                                       {% () => Math.min %}
              | "avg" | "mean"                              {% () => mean %}
              | "sum"                                       {% () => sum %}
              | "mul"                                       {% () => mul %}
              | "median"                                    {% () => mean %}

NAryFuncArgs -> NAryFuncArgs _ ";" _ Range                  {% ([args,,,range]) => [...args, range] %}
              | Range                                       # pass through as array

Range        -> Reference ":" Reference                     {% ([ref1,,ref2]) => new CellRange(ref1, ref2) %}
              | Literal                                     {% id %}

Literal      -> %number                                     {% ([v]) => parseFloat( v.value.replace( /,/g, '.' ) ) %}
              | "e"                                         {% () => Math.E %}
              | "pi"                                        {% () => Math.PI %}
              | Reference                                   {% id %}

Reference    -> CellRef                                     {% id %}  # TODO : other types of references

CellRef      -> %word %number                               {% ([col, row]) => new CellReference(col, parseInt(row)) %}

_            -> %whitespace:?                               {% () => null %}