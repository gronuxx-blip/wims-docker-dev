# [WIMS USER] Updating GeogebraWeb Library :

If you want tu use the latest ggb library adaptated to your WIMS version, just update your Geogebraweb-WIMS:

	./compile --geogebra

# Test your GeogebraWeb Installation
There are several WIMS modules using GegebraWeb.
You can test for example one of these:

## mode "web3d":
* [H1/geometry/OEFtriang5.fr](http://localhost/wims/wims.cgi?module=H1/geometry/OEFtriang5.fr&cmd=new&exo=constr1)
* [H2/geometry/oefevalwimssym.fr](http://localhost/wims/?cmd=new&module=H2/geometry/oefevalwimssym.fr&exo=conservation2)
* [H3/geometry/oefprogpythag.fr](http://localhost/wims/wims.cgi?module=H3/geometry/oefprogpythag.fr&cmd=new&exo=experim)
* [U1/geometry/docisometriesplan.fr](http://localhost/wims/wims.cgi?module=U1%2Fgeometry%2Fdocisometriesplan.fr&+cmd=new&+job=read&+doc=1&+block=mainS2S1S1)


## mode "webSimple":
* [H5/geometry/vecteurs.fr](http://localhost/wims/wims.cgi?module=H5%2Fgeometry%2Fvecteurs.fr&cmd=new&job=read&doc=1&block=mainS1S1) 


---
# [WIMS DEV] Upgrading GeogebraWeb Library :
[Self-Hosted solution](https://wiki.geogebra.org/en/Reference:GeoGebra_Apps_Embedding#Offline_and_Self-Hosted_Solution)

## Download new version

* Download the latest GGB bundle at [dev.geogebra.org/download/web](http://dev.geogebra.org/download/web/)
ou lien direct (latest) ==> https://download.geogebra.org/package/geogebra-math-apps-bundle
    * Usually, it is the [geogebra-math-apps-bundle-5-xxx.zip](https://dev.geogebra.org/download/web/geogebra-math-apps-bundle-5-0-700-0.zip)

* unzip it and use the content of HTML5/5.0 to replace the geogebraweb folder

## Modify "deployggb.js"
replace your deployggb.js by the one included in the zip you just downloaded

## Adapt GGB code for WIMS

### Hack WIMS 1 :
GGB use it's own hosted library. To use WIMS included GGB version, replace the original *codebase* URL in *deployggb.js* by this:

    codebase="https://www.geogebra.org
nb : the original `getTubeURL` function finish by `return tubeurl};`

### Hack WIMS 2 :
Then, replace in "deployggb.js" `webModule.__moduleBase="https://www.geogebra.org..."+name+"/";`
 by `webModule.__moduleBase="scripts/js/geogebra/geogebraweb/"+name+"/";`

### Hack WIMS 3 :
Since WIMS 4.x still use ISO-xxx charsets (not UTF-8), you must add this to each geogebra "####.cache.js" files (web/ & web3d/):

1. first search for string "js/properties_keys"
2. when found, find the function associated "D2l(d+'js/pr..." => D2l
3. search this function, like "function D2l("
4. add a "c.charset='utf-8';" after the creatElement(...)


Don't forget to clean your browser cache, and then

## Test the new version on existing modules
See the [WIMS USER] section for samples of exercices to be tested.

## Publish new GGBWeb version into WIMS
* duplicate your geogebraweb folder
* rename it "GeoGebraWeb-WIMS-5.X.YYY.0", so it contains the new version number
* zip it
* If you'r on MacOS X :
	* `for file in *.zip; do zip "$file" -d "__MACOSX/*"; done`
    * `for file in *.zip; do zip "$file" -d "\*/.DS_Store"; done`
* send it to wims.univ-cotedazur.fr/download server (ask his administrator [bado@unice.fr](mailto:bado@unice.fr))
* Update the variable vGeogebra in the ./compile file at WIMS root, so it contains the new Geogebra number version
* remove the duplicated folder and the zip archive

## See More...
Nb : if you're curious to see non-obfuscated geogebra code, you have to follow these explanations :
[dev.geogebra.org/trac/wiki/SetUp](https://dev.geogebra.org/trac/wiki/SetUp)
