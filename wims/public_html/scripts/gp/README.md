coxhyp.gp: replaced by  pavage_hyper.gp\
\
deploiement.gp: use in slib polynet\
grapheuler.gp: use in slib eulerian_graph to draw an eulerian graph\
spanning_tree.gp: use in slib polynet\
phase.gp: see in slib/analysis/phase.gp\
circlepack.gp: circle packing\
\
hyptiling.gp: use in slib hyptiling\
  abc:S'il existe un triangle de côtés a,b,c et angles opposes A,B,C, ces fonctions\
    renvoient les paramètres manquants. Sinon, renvoie 0\
  Polygones tangentiels: tangentiel\
    Entree: n angles entre 0 et Pi, dont la somme est inferieure a (n-2)*Pi\
    Sortie: [res,R] ou\
      res est un polygone convexe d'angles interieurs a_i\
      dont tous les cotes sont tangents a un meme cercle de rayon (hyperbolique) R,\
      Si le parametre centre est non nul, le centre du polygone est 0 et res[1] reel positif\
      Sinon, le cote [res[n],res[1]] est porte par l'axe reel et le cercle lui est tangent\
      au point 0. Le centre est donc R*I\
  hyp_pav : Pavage obtenu a partir d'un polygone convexe pavant\
    Entree:  v_i, n points du disque de Poincare et d_i>2 des entiers\
      On suppose que les v_i forment le bord oriente d'un polygone convexe (pave) P0\
      dont l'angle intérieur au point v_i est  2Pi/d_i\
      Si d_i est impair, les deux cotes qui touchent v_i consecutifs sont supposes egaux\
      z0 est cense etre un point quelconque du polygone\
      Si eps<1, renvoie les paves dont au moins un sommet est dans le disque euclidien D(0,1-eps)\
      Si eps>=1, on s'en sert comme limite sur le nombre de paves.\
    Sortie: [sommets, paves, aretes, centres, aretes_duales]\
      Un sommet est un couple [affixe, type]\
      Un pave est un tableau de n entiers (numeros de sommets) et une transformation de Mobius\
      Une arete est un vecteur a 5 composantes\
      [origine, extremite, type, numero du premier pave que l'arete borde, sur le bord ?]\
      Les centres sont les images de z0 dans chaque pave.\
      Une arete duale est un vecteur a 3 composantes\
      [pave_origine, pave_extremite, arete croisee]\
  catalan:\
    On se donne n entiers d[i]>=3, avec la convention d[] périodique modulo n\
    On suppose que si d[i] est impair, alors on a d[i-1]=d[i+1].\
    Calcule le pavage associé au polygone tangentiel d'angles interieurs 2*Pi/d[i]\
