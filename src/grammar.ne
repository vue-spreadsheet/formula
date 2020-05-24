@include "../node_modules/math-ref-parser/src/grammar.ne"

@{%
import { CellReference, Formula } from './ast';
%}

Expression   -> Sum                                         {% ([sum]) => new Formula(sum) %}

Reference    -> CellRef                                     {% id %}

CellRef      -> %word %number                               {% ([col, row]) => new CellReference(col.value, parseInt(row.value)) %}
