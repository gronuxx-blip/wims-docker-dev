# WIMS External packages

We use `Yarn` to automatically download JS packages/plugins,
And then we use `Grunt` to perform special tasks (concat, minify, verify ...)

## Installation

### Install Yarn

* See here: [install Yarn](https://yarnpkg.com)

```sh
brew install yarn
```

### Install Grunt

```sh
yarn upgrade
yarn global add grunt-cli
```

## Manage Packages

### Audit each dependency if there is a known issue to fix

```sh
yarn audit
```

### Update Javascripts plugins

```sh
yarn upgrade
```

## Download new Package(s)

```sh
yarn add <package>
```

nb: When upgrading TinyMCE 6, you must also manually download language packs here :
<https://www.tiny.cloud/get-tiny/language-packages/>
(i.e for French: <https://download.tiny.cloud/tinymce/community/languagepacks/6/fr_FR.zip>)

## Migrate files from _packages/ to wims/

  After each update, Grunt is handy to automatically compress js + css, and move each files at is wims destination. simply call "grunt"

```sh
# First, compile JSXGraph
cd node_modules/jsxgraph
npm install
npm run buildCore
# Then, do WIMS things
cd ../..
grunt
yarn run build
```

## Test & Check

After each js package update, look at these URL:

* jquery-ui
  * Tabs : [searchform](http://localhost/wims/?cmd=new&module=home&search_keywords=oef&search_category=A&search_lang=fr#searchform)
  * Menu : [H6/algebra/docnatural.fr](http://localhost/wims/?module=H6/algebra/docnatural.fr)
* jsXgraph
  * [U1/geometry/oeftiling.fr](http://localhost/wims/?module=U1/geometry/oeftiling.fr&cmd=new&exo=translation)
* mathlive
  * ??
* CodeMirror 5
  * slib/coding/editor : [H4/programming/pixelart.fr](http://localhost/wims/wims.html?&cmd=new&module=H4/programming/pixelart.fr)
* jQuery
  * needed at least by Jquery UI
* jQuery-hoverintent
  * ??
* jQuery-ui-Slider-Pips
  * Level filter in "Searching for a teaching material" on WIMS home <http://localhost/wims/>
* slick-carousel
  * "Samples" on WIMS home <http://localhost/wims/>
* Marked
  * <http://localhost/wims/wims.html?module=help%2Fwimsdoc.en&+cmd=new&+style=integral#anstype_content>
* chart.js
  * <http://localhost/wims/wims.html?cmd=new&module=adm%2Fstat%2Fstat&special_parm=module_updates>

## Cleaning

```sh
yarn cache clean
yarn autoclean --force
```

## Documentations

* [Yarn docs](https://yarnpkg.com/docs)
* [Grunt HowTo (video fr)](http://www.grafikart.fr/tutoriels/grunt/grunt-introduction-470)
* [Grunt "getting started"](http://gruntjs.com/getting-started)

## JSXGraph

```sh
cd node_modules/jsxgraph
npm install
npm run buildCore
```
