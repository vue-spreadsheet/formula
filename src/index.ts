import nearley from 'nearley';
// @ts-ignore
import grammar from './grammar';
import { Formula } from './ast';


export default function parseFormula( formula: string ): Formula {
  const formulaParser = new nearley.Parser( nearley.Grammar.fromCompiled( grammar ) );
  formulaParser.feed( formula );
  return formulaParser.results[ 0 ];
}