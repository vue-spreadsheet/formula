import { Evaluatable, Operation, Range, registerRangeClass } from 'math-ref-parser';


// TODO : this class could be provided by math-ref-parser
export class Formula extends Operation {

  constructor(
    ast: Evaluatable,
  ) {
    super(ast);
  }

  protected execute( values: any ): any {
    return this.args[0].computedValue;
  }

}


// TODO : reference should be a type param for range
export class CellRange extends Range {

  protected start: CellReference;
  protected end: CellReference;

  get computedValue() {

    const result = [];

    if ( this.referenceData ) {
      for ( let r = this.start.row; r <= this.end.row; r++ ) {
        for ( let c = this.start.column; c <= this.end.column; c++ ) {
          result.push( this.referenceData[ r ][ c ] );
        }
      }
    }

    return result;
  }
}


export class CellReference extends Evaluatable {
  column: number;
  row: number;

  constructor(
    columnName: string,
    row: number,
  ) {
    super();

    // TODO : multi-char column names
    this.column = columnName.toLowerCase().charCodeAt( 0 ) - 'a'.charCodeAt( 0 );
    this.row = row - 1;
  }

  get computedValue() {
    // TODO : handling of out of bounds stuff?
    return this.referenceData?.[ this.row ]?.[ this.column ];
  }

}


registerRangeClass( CellRange );