/*
 * Content-seperated javascript tree widget
 * Copyright (C) 2005 SilverStripe Limited
 * Feel free to use this on your websites, but please leave this message in the fies
 * http://www.silverstripe.com/blog
*/

/*
 * Initialise all trees identified by <ul class="tree">
 */

/**
 * Usefull function for popup window displaying
 * @param {*} mylink
 * @param {*} windowname
 * @returns
 */
function popup(mylink, windowname){
  if (! window.focus)return true;
  var href;
  if (typeof(mylink) == 'string')
    href=mylink;
  else
    href=mylink.href;
  window.open(href, windowname, 'width=800,height=500,scrollbars=yes');
  return false;
}

/**
 * autoInit_trees
 */
function autoInit_trees() {
  //console.log("autoInit_trees");
  var candidates = document.getElementsByTagName('ul');
  for(var i=0;i<candidates.length;i++) {
    if(candidates[i].className && candidates[i].className.indexOf('tree') != -1) {
      initTree(candidates[i]);
      candidates[i].className = candidates[i].className.replace(/ ?unformatted ?/, ' ');
    }
  }
}

/**
 * Initialise a tree node, converting all its LIs appropriately
 * @param {*} el
 * @returns
 */
function initTree(el) {
  //console.log("initTree");
  var i,j;
  var spanA, spanB, spanC;
  var startingPoint, stoppingPoint, childUL;

  // Find all LIs to process
  for(i=0;i<el.childNodes.length;i++) {
    if(el.childNodes[i].tagName && el.childNodes[i].tagName.toLowerCase() == 'li') {
      var li = el.childNodes[i];

      // Create our extra spans
      spanA = document.createElement('span');
      spanB = document.createElement('span');
      spanC = document.createElement('span');
      spanA.appendChild(spanB);
      spanB.appendChild(spanC);
      spanA.className = 'a ' + li.className.replace('closed','spanClosed');
      spanA.onMouseOver = function() {}
      spanB.className = 'b';
      spanB.onclick = treeToggle;
      spanC.className = 'c';

      // Find the UL within the LI, if it exists
      stoppingPoint = li.childNodes.length;
      startingPoint = 0;
      childUL = null;
      for(j=0;j<li.childNodes.length;j++) {
        if(li.childNodes[j].tagName && li.childNodes[j].tagName.toLowerCase() == 'div') {
          startingPoint = j + 1;
          continue;
        }

        if(li.childNodes[j].tagName && li.childNodes[j].tagName.toLowerCase() == 'ul') {
          childUL = li.childNodes[j];
          stoppingPoint = j;
          break;
        }
      }

      // Move all the nodes up until that point into spanC
      for(j=startingPoint;j<stoppingPoint;j++) {
        spanC.appendChild(li.childNodes[startingPoint]);
      }

      // Insert the outermost extra span into the tree
      if(li.childNodes.length > startingPoint) {
        li.insertBefore(spanA, li.childNodes[startingPoint]);
      } else {
        li.appendChild(spanA);
      }

      // Process the children
      if(childUL != null) {
        if(initTree(childUL)) {
          li.classList.add('children');
          spanA.classList.add('children');
        }
      }
    }
  }

  if(li) {
    // li and spanA will still be set to the last item
    li.classList.add('last');
    spanA.classList.add('last');
    return true;
  } else {
    return false;
  }
}

/**
 * +/- toggle the tree
 *
 * @param {*} el the <span class="b"> node
 * @param {*} force will force it to "open" or "close"
 */
function treeToggle(el, force) {
  //console.log("treeToggle");
  el = this;
  while(el != null && (!el.tagName || el.tagName.toLowerCase() != "li")) el = el.parentNode;

  // Get UL within the LI
  var childSet = findChildWithTag(el, 'ul');
  var topSpan = findChildWithTag(el, 'span');

  if( force != null ){
    if( force == "open"){
      treeOpen( topSpan, el )
    } else if( force == "close" ){
      treeClose( topSpan, el )
    }
  } else if( childSet != null) {
    // Is open, close it
    if(!el.className.match(/(^| )closed($| )/)) {
      treeClose( topSpan, el )
    // Is closed, open it
    } else {
      treeOpen( topSpan, el )
    }
  }
}

/**
 * treeOpen
 * @param {*} a
 * @param {*} b
 */
function treeOpen(a, b ){
  //console.log("treeOpen");
  a.classList.remove('spanClosed');
  b.classList.remove('closed');
}

/**
 *  * [Jquery] treeToggleAll : Open/close all tree inside "elem"
 * elem can be a css id (#ident) or a css class (.classname)
 * added by obado
 * @param {*} elem
 */
function treeToggleAll( elem ){
  //console.log("treeToggleAll");
  //$(elem+" .children").toggleClass("closed");
  if ($(elem).hasClass("all_open")){
    $(elem+" .children").addClass("closed");
    $(elem).removeClass("all_open");
  }
  else{
    $(elem+" .children").removeClass("closed");
    $(elem).addClass("all_open");
  }
}

/**
 * treeClose
 * @param {*} a
 * @param {*} b
 */
function treeClose(a, b ){
  //console.log("treeClose");
  a.classList.add('spanClosed');
  b.classList.add('closed');
}

/**
 * Find the a child of el of type tag
 * @param {*} el
 * @param {*} tag
 * @returns
 */
function findChildWithTag(el, tag) {
  //console.log("findChildWithTag");
  for(var i=0;i<el.childNodes.length;i++) {
    if(el.childNodes[i].tagName != null && el.childNodes[i].tagName.toLowerCase() == tag) return el.childNodes[i];
  }
  return null;
}

/**
 * Functions to add and remove class names
 * Mac IE hates unnecessary spaces
 * @param {*} el
 * @param {*} cls
 * @param {*} forceBefore
 */
function addClass(el, cls, forceBefore) {
  //console.log(`addClass ${cls}`);
  if(forceBefore != null && el.className.match(new RegExp('(^| )' + forceBefore))) {
    el.className = el.className.replace(new RegExp("( |^)" + forceBefore), '$1' + cls + ' ' + forceBefore);

  } else if(!el.className.match(new RegExp('(^| )' + cls + '($| )'))) {
    el.className += ' ' + cls;
    el.className = el.className.replace(/(^ +)|( +$)/g, '');
  }
}

/**
 * removeClass
 * @param {*} el
 * @param {*} cls
 */
function removeClass(el, cls) {
  //console.log("removeClass");
  var old = el.className;
  var newCls = ' ' + el.className + ' ';
  newCls = newCls.replace(new RegExp(' (' + cls + ' +)+','g'), ' ');
  el.className = newCls.replace(/(^ +)|( +$)/g, '');
}

/*
 * Handlers for automated loading
 */
_LOADERS = Array();

/**
 * callAllLoaders
 */
function callAllLoaders() {
  var i, loaderFunc;
  for(i=0;i<_LOADERS.length;i++) {
    loaderFunc = _LOADERS[i];
    if(loaderFunc != callAllLoaders) loaderFunc();
  }
}

/**
 * appendLoader
 * @param {*} loaderFunc
 */
function appendLoader(loaderFunc) {
  if(window.onload && window.onload != callAllLoaders)
    _LOADERS[_LOADERS.length] = window.onload;

  window.onload = callAllLoaders;

  _LOADERS[_LOADERS.length] = loaderFunc;
}

appendLoader(autoInit_trees);
