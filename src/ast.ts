abstract class Evaluatable {
  abstract get computedValue();
}


abstract class Operation extends Evaluatable {
  args;

  constructor( ...args: ( Number | Evaluatable )[] ) {
    super();

    this.args = args;
  }

  get computedValue() {
    const values = [];
    for ( const arg of this.args ) {
      if ( arg instanceof Evaluatable ) {
        values.push( arg.computedValue );
      } else {
        values.push( arg );
      }
    }

    return this.execute( values );
  }

  protected abstract execute( values );

}


export class Difference extends Operation {
  protected execute( [ l, r ] ) {
    return l - r;
  }
}


export class Division extends Operation {
  protected execute( [ l, r ] ) {
    return l / r;
  }
}


export class Modulo extends Operation {
  protected execute( [ l, r ] ) {
    return l % r;
  }
}


export class Power extends Operation {
  protected execute( [ l, r ] ) {
    return Math.pow( l, r );
  }
}


export class UnaryFunction extends Operation {
  constructor( protected func: ( x: Number ) => Number, arg ) {
    super( arg );
  }

  protected execute( [ x ] ) {
    return this.func( x );
  }
}


export class NAryFunction extends Operation {
  constructor( protected func: ( ...args: Number[] ) => Number, args ) {
    super( ...args );
  }

  protected execute( args: Number[] ) {
    return this.func( ...args );
  }

}


// adapted from: https://gist.github.com/Daniel-Hug/7273430
export function sum( ...args ) {
  let result = 0;
  for ( const arg of args ) {
    result += arg;
  }
  return result;
}

export function mul( ...args ) {
  let result = 1;
  for ( const arg of args ) {
    result *= arg;
  }
  return result;
}

export function mean( ...args ) {
  return sum( args ) / args.length;
}

export function median( ...args ) {
  // TODO : there is a more efficient implementation
  args.sort( function ( a, b ) {
    return a - b;
  } );
  const mid = args.length / 2;
  return mid % 1 ? args[ mid - 0.5 ] : ( args[ mid - 1 ] + args[ mid ] ) / 2;
}


export class CellRange extends Evaluatable {
  constructor(
    protected start: CellReference,
    protected end: CellReference,
  ) {
    super();
  }

  get computedValue() {
    // TODO : implement

    return this.start.computedValue + this.end.computedValue;
  }
}


export class CellReference extends Evaluatable {
  constructor(
    protected column: string,
    protected row: number,
  ) {
    super();
  }

  get computedValue() {
    // TODO : implement

    return Math.random() * 100;
  }

}