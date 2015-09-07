HTMLWidgets.widget({

  name: 'InCHlib',

  type: 'output',

  initialize: function(el, width, height) {

    //var inchlib = new InCHlib({
    //  target: "inchlib",
    //  metadata: true,
    //  column_metadata: true,
    //  max_height: 1200,
    //  width: 1000,
    //  heatmap_colors: "Greens",
    //  metadata_colors: "Reds"
    //});

    // return it as part of our instance data
    return {
      inchlib: inchlib
    };

  },

  renderValue: function(el, x, instance) {

    //inchlib.read_data(x.jsondata);
    //inchlib.draw();

  },

  resize: function(el, width, height, instance) {

  }

});
