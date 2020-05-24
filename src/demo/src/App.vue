<template>
  <div class="columns">
    <div class="column">

      <div class="panel is-info">
        <p class="panel-heading">
          Formula
        </p>
        <div class="panel-block">
          <p class="control has-icons-left">
            <input class="input" type="text" placeholder="Formula" v-model="formula">
            <span class="icon is-left">
              <i class="fas fa-calculator" aria-hidden="true"></i>
            </span>
          </p>
        </div>
        <div class="panel-block">
          <p class="control has-icons-left">
            <input class="input" type="text" placeholder="Result" readonly :value="result">
            <span class="icon is-left">
              <i class="fas fa-equals" aria-hidden="true"></i>
            </span>
          </p>
        </div>
        <div class="panel-block" v-if="error !== null">
          <pre class="message is-danger">{{ error }}</pre>
        </div>
      </div>

    </div>

    <div class="column">
      <div class="panel">
        <p class="panel-heading">
          Table
        </p>
        <div class="panel-block">
          <table class="table is-fullwidth is-bordered">
            <thead>
            <tr>
              <th></th>
              <th align="right">A</th>
              <th align="right">B</th>
              <th align="right">C</th>
              <th align="right">D</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="row in 10">
              <th align="right">{{ row }}</th>
              <td align="right" v-for="col in 4" :ref="row + col*4">
                <input type="number" v-model="tableData[row - 1][col - 1]">
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>

</template>

<script>
  import parseFormula from "@vue-spreadsheet/formula";


  export default {

    data: () => {
      const tableData = [];

      for ( let i = 0; i < 10; i++ ) {
        const row = [];
        for ( let j = 0; j < 4; j++ ) {
          row.push( Math.round( ( Math.random() * 100 ) ) );
        }
        tableData.push( row );
      }

      return {
        formulaString: '',
        ast: null,
        error: null,
        tableData
      };
    },

    computed: {
      formula: {
        get() {
          return this.formulaString;
        },

        set( value ) {
          try {
            this.ast = parseFormula( value );
            if ( this.ast ) {
              this.ast.setReferenceData( this.tableData );
            }
            this.error = null;
          } catch ( e ) {
            this.error = e.message;
          }
          this.formulaString = value;
        }
      },

      result() {
        if ( this.ast ) {
          console.log( JSON.stringify(
            this.ast,
            ( ( key, value ) => key === 'referenceData' ? undefined : value ),
            2
          ) );
        }
        return this.ast && this.ast.computedValue || '';
      }
    },
  };
</script>
