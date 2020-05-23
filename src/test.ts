import nearley from 'nearley';
// @ts-ignore
import grammar from './grammar';


const parser = new nearley.Parser( nearley.Grammar.fromCompiled( grammar ) );

parser.feed( '3 + sin(4 * 5^2) * (4 + sum(A11:B14) )' );

console.log( parser.results[0][0].computedValue );