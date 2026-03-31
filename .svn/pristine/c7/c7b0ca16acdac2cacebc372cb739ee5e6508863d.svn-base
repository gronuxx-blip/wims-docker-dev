!set slib_header_coxaff=\
\\ Polynome minimal de 2*cos(Pi/n)\
real_cyclo(n)={\
 if(n==1,return(x+2));\
 my(p=polcyclo(2*n),nn=eulerphi(2*n)/2,res=0,c);\
 forstep(j=nn,0,-1,\
   c = polcoeff(p,nn+j);\
   res += c*x^j;\
   p -= c*x^(nn-j)*(x^2+1)^j);\
 res\
};\
\
\\ p(2*cos(t)) = 2*cos(n*t)\
cheby(n)=2*subst(polchebyshev(n),x,x/2);\
\
\\ m est une matrice de Coxeter\
\\ renvoie les generateurs\
cox_base(m)={\
  my(n=#m,nn=1);\
  for(i=1,n,for(j=i+1,n,if(m[i,j],nn=lcm(nn,m[i,j]))));\
  xx=Mod(x,real_cyclo(nn));\
  module=xx.mod;\
  racine=2*cos(Pi/nn);\
  gram=matrix(n,n,i,j,if(m[i,j],-cos(Pi/m[i,j]),-1));\
  v=vector(n,k,matrix(n,n,i,j,\
    (i==j)+(i==k)*lift(subst(if(m[k,j],cheby(nn/m[k,j]),2),x,xx))));\
  Set(v)\
};\
\
longer(shorter,current,cb)={\
  my(l=List());\
  foreach(current,w,foreach(cb,s,\
    listput(l,simplify((w*s)%module))));;\
  setminus(Set(l),shorter)\
};\
\
\\ Sous l'hypothese 1/p+1/q+1/r=1\
\\ imprime le source tikz d'un pavage d'une partie\
\\ du plan avec des triangles d'angles Pi/p, etc.\
aff3(p,q,r,limite)={\
  my(g,t=matrix(3,3),u,v,acc,cb=cox_base([1,p/2,q/2;p/2,1,r/2;q/2,r/2,1]),\
  sh=Set(),cr=Set(matid(3)),tmp,h,res,xmin,xmax,ymin,ymax,xm,ym);\
  for(i=1,3,\
    g=subst(cb[i]*cb[1+(i%3)],x,racine);\
    \\point fixe de g, moyenne des iteres : intersection de la droite de points fixes, puis z=1\
    u=if(i==1,p/2,if(i==2,r/2,q/2));\
    v=[0,0,1];\
    acc=vector(3);\
    for(i=1,u,acc+=v;v=v*g);\
    t[i,]=acc/u);\
  \\printf("p: %d, q: %d, r: %d\n",p, q, r);\
  res=matrix(0,7);\
  \\printf("\\begin{tikzpicture}[scale=%.3f]\n",7/limite);\
  for(i=1,limite, tmp=longer(sh,cr,cb); sh=cr; cr=tmp;\
    foreach(sh,g,h=t*subst(g,x,racine)*[1,0;cos(2*Pi/p),sin(2*Pi/p);0,0];\
      \\printf("\\%s(%.4f,%.4f)--(%.4f,%.4f)--(%.4f,%.4f)--cycle;\n",\
        \\if(i%2,"fill","draw"),h[1,1],h[1,2],h[2,1],h[2,2],h[3,1],h[3,2]);\
        res=matconcat([res,[h[1,1],h[1,2],h[2,1],h[2,2],h[3,1],h[3,2],i%2]]~)\
	));\
  \\print("\\end{tikzpicture}\n");\
  for(i=1,matsize(res)[1],for(j=1,3,xm=res[i,2*j-1];ym=res[i,2*j];\
    if(xm<xmin,xmin=xm);\
    if(xm>xmax,xmax=xm);\
    if(ym<ymin,ymin=ym);\
    if(ym>ymax,ymax=ym)));\
  [[xmin,xmax,ymin,ymax],res];\
};\
/*\
\p3\
print("\nAffines\n");\
aff3(4,8,8,20);\
aff3(6,6,6,20);\
aff3(4,6,12,20);\
*/\
\
