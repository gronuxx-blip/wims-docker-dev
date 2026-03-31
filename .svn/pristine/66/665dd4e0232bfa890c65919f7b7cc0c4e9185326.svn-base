module.exports = function(grunt){

  grunt.initConfig({

    // Vérifie que nos js sont corrects (on considere que les js des librairies le sont deja.)
    eslint: {
      /*all: ['../../scripts/js/*.js'],*/
      /*ASCII: ['../../scripts/js/ASCII*.js'],*/
      /*utils: ['../../scripts/js/utils.js'],*/
      /*wz: ['../../scripts/js/wz*.js'],*/
      interface: ['../../scripts/js/interface/*.js'],
      /*geogebra: ['../../scripts/js/geogebra/*.js'],*/
      /*inc: ['../_inc/*.js'],*/
    },

    /* Concatene plusieurs fichiers en un seul
    concat: {
      options: {
        // ajoute automatiquement des ";" entre les javascripts, au cas ou il en manque.
        separator: ';',
      },
      dist: {
        src: ['node_modules/jquery/dist/jquery.min.js'],
        dest: 'grunt_tests/built.js',
      },
    },*/

    /* Concatene et minifie les fichiers JS.*/
    uglify: {
      options: {
        // mangle permet de renommer les variables JS.
        mangle: false,
        output: {
          // preserve comments
          comments: '/==============/'
        }
      },
      ASCIIMathML: {
        files: {
          '../../scripts/js/ASCIIMathML.js': ['node_modules/asciimathml/ASCIIMathML.js']
        }
      },
      LaTeXMathML: {
        files: {
          '../../scripts/js/LaTeXMathML.js': ['node_modules/asciimathml/LaTeXMathML.js']
        }
      },
      Geogebra: {
        files: {
          '../../scripts/js/geogebra/deployggb.min.js': ['../../scripts/js/geogebra/deployggb.js']
        }
      }
    },

    // Concatene et minifie les fichiers CSS.
    cssmin: {
      options: {
        shorthandCompacting: true,
        roundingPrecision: -1,
        keepSpecialComments: "*",
        /*rebase: true /* change all paths inside css file */
      },
      normalize: {
        files: {
          "../../scripts/js/external/normalize.min.css": ["node_modules/normalize.css/*.css"]
        }
      },
      /*carousel:{
        files: {
          "../../scripts/js/external/slick/slick.min.css": ["node_modules/@accessible360/accessible-slick/slick/slick.scss"]
        }
      }*/
    },

    // Copie les fichiers vers leur répertoire définitif
    copy: {
      main: {
        files: [
          // includes all minified files within path "jquery/dist"
          {
           expand: true,
           flatten: true,
           filter: 'isFile',
           src: ['node_modules/jquery/dist/*.min.*'],
           dest: '../../scripts/js/external/jquery/'
          },

          /*** JQuery UI ***/
          // includes all minified files within path "jquery-ui/"
          {
           expand: true,
           flatten: true,
           src: ['node_modules/jquery-ui-dist/*.min.*'],
           dest: '../../scripts/js/external/jquery-ui/'
          },
          // includes all translated files for jquery-ui"
          {
           expand: true,
           flatten: true,
           src: ['node_modules/jquery-ui/ui/i18n/*.js'],
           dest: '../../scripts/js/external/jquery-ui/ui/i18n/'
          },
          // includes smoothness theme for jquery-ui"
          {
           expand: true,
           flatten: true,
           src: ['node_modules/jquery-ui/themes/smoothness/*.min.css'],
           dest: '../../scripts/js/external/jquery-ui/themes/smoothness/'
          },
          // includes smoothness images for jquery-ui"
          {
           expand: true,
           flatten: true,
           src: ['node_modules/jquery-ui/themes/smoothness/images/*'],
           dest: '../../scripts/js/external/jquery-ui/themes/smoothness/images/'
          },
          // includes "base" theme for jquery-ui"
          {
           expand: true,
           flatten: true,
           src: ['node_modules/jquery-ui/themes/base/*.min.css'],
           dest: '../../scripts/js/external/jquery-ui/themes/base/'
          },
          // includes "base" images for jquery-ui"
          {
           expand: true,
           flatten: true,
           src: ['node_modules/jquery-ui/themes/base/images/*'],
           dest: '../../scripts/js/external/jquery-ui/themes/base/images/'
          },
          // includes all minified files within path "jquery-ui-slider-pips/"
          {
           expand: true,
           flatten: true,
           src: ['node_modules/jquery-ui-slider-pips/dist/*.min.*'],
           dest: '../../scripts/js/external/jquery-ui-slider-pips/'
          },

          // safari_mobile_links
          /*{
            expand: true,
            filter: 'isFile',
            src: ['node_modules/safari_mobile_links/compressed.js'],
            dest: '../../scripts/js/external/safari_mobile_links/',
          },*/

          /* hoverIntent
          {
            expand: true,
            flatten: true,
            filter: 'isFile',
            src: ['node_modules/jquery-hoverIntent/*.min.js'],
            dest: '../../scripts/js/external/hoverIntent/',
          },*/
          // what-input
          {
            expand: true,
            flatten: true,
            filter: 'isFile',
            src: ['node_modules/what-input/dist/*.min.*'],
            dest: '../../scripts/js/external/what-input/',
          },
          // Chart.js
          {
            expand: true,
            flatten: true,
            filter: 'isFile',
            src: ['node_modules/chart.js/dist/*.umd.js'],
            dest: '../../scripts/js/external/chart.js/',
          },
          // jsxGraph
          {
            expand: true,
            filter: 'isFile',
            flatten: 'true',
            src: ['node_modules/jsxgraph/distrib/jsxgraph*', 'node_modules/jsxgraph/distrib/geo*'],
            //dest: '../../scripts/js/external/jsxgraph/',
            dest: '../../scripts/js/jsxgraph/',
          },
          // Slick Carousel
          {
            expand: true,
            filter: 'isFile',
            flatten: 'true',
            src: ['node_modules/@accessible360/accessible-slick/slick/*.min.js','node_modules/@accessible360/accessible-slick/slick/*.gif','node_modules/@accessible360/accessible-slick/slick/*.css'],
            dest: '../../scripts/js/external/slick/',
            // ici il faudrait faire un rename du theme slick accessible en "slick-theme" tout court.
          },{
            expand: true,
            filter: 'isFile',
            flatten: 'true',
            src: ['node_modules/@accessible360/accessible-slick/slick/fonts/*'],
            dest: '../../scripts/js/external/slick/fonts/',
          },
          // Slideout.js
          /*{
            expand: true,
            filter: 'isFile',
            flatten: 'true',
            src: ['node_modules/slideout.js/dist/*.min.js', 'node_modules/slideout.js/*.css' ],
            dest: '../../scripts/js/slideout/',
          },*/
          /* ASCIIMathML (+LaTeXMathML)
          {
            expand: true,
            flatten: true,
            filter: 'isFile',
            src: ['node_modules/asciimathml/*.js' ],
            dest: '../../scripts/js/',
          },*/
          /* Marked js (Markdown parser) */
          {
            expand: true,
            flatten: true,
            filter: 'isFile',
            src: ['node_modules/marked/*.js'],
            dest: '../../scripts/js/external/marked/',
          }

        ],
      },

      // MathJax specific copying task (it could be long)
      /*MathJax: {
        files: [
          {
            expand: true,
            src: ['node_modules/MathJax/**' ],
            dest: '../../scripts/js/',
          },
        ],
      },*/
    },

    // RSYNC
    /*rsync: {
      options: {
          args: ["--verbose"],
          exclude: [".git*","*.scss","node_modules"],
          recursive: true
      },
      MathJax: {
          options: {
              src: "./node_modules/MathJax/",
              dest: "../../scripts/js/mathjax"
          }
      }
    }*/

  });

  /* available jobs */
  grunt.loadNpmTasks('grunt-eslint');
  /*grunt.loadNpmTasks('grunt-contrib-concat');*/
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-copy');
  //grunt.loadNpmTasks("grunt-rsync");

  /* Defined Tasks */
  grunt.registerTask('default', ['eslint', 'uglify', 'cssmin', 'copy:main']);
  //grunt.registerTask('mathjax', ['copy:MathJax']);
  grunt.registerTask('mathjax', ['rsync:MathJax']);

};
